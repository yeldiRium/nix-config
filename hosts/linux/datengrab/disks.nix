{
  config,
  lib,
  pkgs,
  ...
}:
let
  authorizedKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCf4PuMuh6umz5hvl3u0sT20TP6+EKnOHKjy3uUjYCMjXMtjC83u5TKEl//oZ70g96Kn5w3KEN169ektClvHFJx8nOiZXAI617xVjTkYHtbpDaZOyaPNER23TQ+BNDarhAjtY9RAjgsO0M0wqfg69ElP6+UFl/MM+txjGnf3NasaDto5/bRNIBssBg++FI9xUHW/urD6hddRZ8iBIHxud8qezM9/a6+Q2/5AhBOmJy4MysWea1PP8jA2kbSDjUCNGA4w24pJzyVU8qB8WMWfIkkvUFCSQ/o0UZ133eoEZBGdTMW/oxI/wsUOqyBvbAkpJWPJH4LQqfopLfPjguI5QXj hannes.leutloff@yeldirium.de"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE45YijDajl0VRD56CFDgvjDjfF+FuOQ4X3QiqaXfvPQ"
  ];
  storageDisks = [
    "sda"
    "sdb"
    "sdd"
    "sde"
  ];
  inherit (config.networking) hostName;
in
{
  config = lib.mkMerge [
    # impermanence
    {
      environment.persistence = {
        "/persist/system" = {
          enable = true;
          hideMounts = true;
          directories = [
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
          ];
          files = [
            "/etc/machine-id"
          ];
        };
      };
      boot.initrd.systemd.suppressedUnits = [ "systemd-machine-id-commit.service" ];
      systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

      fileSystems = {
        "/etc/ssh".neededForBoot = true;
        "/nix".neededForBoot = true;
        "/persist".neededForBoot = true;
      };

      boot.initrd.systemd.services.rollback = {
        wantedBy = [ "initrd.target" ];
        after = [ "zfs-import-zroot.service" ];
        before = [ "sysroot.mount" ];
        path = [ config.boot.zfs.package ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          zfs rollback -r zroot/root@empty
        '';
      };
    }

    {
      # setup initrd ssh to unlock the encripted drive
      boot = {
        kernelParams = [ "ip=::::${hostName}-initrd::dhcp" ];
        initrd = {
          network.enable = true;
          availableKernelModules = [
            "igb"
            "e1000e"
          ];
          network.ssh = {
            enable = true;
            port = 22;
            authorizedKeys = map (key: ''command="systemctl default" ${key}'') authorizedKeys;
            hostKeys = [ "/etc/ssh/initrd" ];
          };
          secrets = {
            "/etc/ssh/initrd" = "/etc/ssh/initrd";
          };
        };
      };
    }

    # zfs configuration and devices
    {
      environment.systemPackages = with pkgs; [
        zfs-prune-snapshots
      ];
      boot = {
        # ZFS does not support swapfiles, disable hibernate and set cache max
        kernelParams = [
          "nohibernate"
          "zfs.zfs_arc_max=17179869184"
        ];
        supportedFilesystems = [
          "zfs"
          "vfat"
          "nfs"
          "ntfs"
          "ext4"
          "exfat"
        ];
        zfs = {
          devNodes = "/dev/disk/by-id/";
          forceImportRoot = false;
        };
      };
      services.zfs = {
        autoScrub.enable = true;
        trim.enable = true;
      };

      disko.devices = {
        disk = lib.mkMerge [
          # SSD root disk and system persistence
          {
            root = {
              type = "disk";
              device = "/dev/sdc";
              content = {
                type = "gpt";
                partitions = {
                  esp = {
                    label = "EFI";
                    name = "ESP";
                    size = "2048M";
                    type = "EF00";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                    };
                  };
                  luks = {
                    size = "100%";
                    content = {
                      type = "luks";
                      name = "crypt-root";
                      settings.allowDiscards = true;
                      passwordFile = "/persist/luks/secret.key";
                      content = {
                        type = "zfs";
                        pool = "zroot";
                      };
                    };
                  };
                };
              };
            };
          }

          # hdd raid storage pool
          (lib.mkMerge (
            map (diskname: {
              "${diskname}" = {
                type = "disk";
                device = "/dev/${diskname}";
                content = {
                  type = "gpt";
                  partitions = {
                    luks = {
                      size = "100%";
                      content = {
                        type = "luks";
                        name = "stg${diskname}";
                        settings.allowDiscards = true;
                        passwordFile = "/persist/luks/secret.key";
                        content = {
                          type = "zfs";
                          pool = "zstorage";
                        };
                      };
                    };
                  };
                };
              };
            }) storageDisks
          ))
        ];
        zpool = {
          zroot = {
            type = "zpool";
            rootFsOptions = {
              canmount = "off";
              checksum = "edonr";
              compression = "zstd";
              dnodesize = "auto";
              mountpoint = "none";
              normalization = "formD";
              relatime = "on";
              "com.sun:auto-snapshot" = "false";
            };
            options = {
              ashift = "12";
              autotrim = "on";
            };
            datasets = {
              etcssh = {
                type = "zfs_fs";
                options.mountpoint = "legacy";
                mountpoint = "/etc/ssh";
                options."com.sun:auto-snapshot" = "false";
                postCreateHook = "zfs snapshot zroot/etcssh@empty";
              };
              persist = {
                type = "zfs_fs";
                options.mountpoint = "legacy";
                mountpoint = "/persist";
                options."com.sun:auto-snapshot" = "false";
                postCreateHook = "zfs snapshot zroot/persist@empty";
              };
              nix = {
                type = "zfs_fs";
                options.mountpoint = "legacy";
                mountpoint = "/nix";
                options = {
                  atime = "off";
                  canmount = "on";
                  "com.sun:auto-snapshot" = "false";
                };
                postCreateHook = "zfs snapshot zroot/nix@empty";
              };
              root = {
                type = "zfs_fs";
                options.mountpoint = "legacy";
                options."com.sun:auto-snapshot" = "false";
                mountpoint = "/";
                postCreateHook = ''
                  zfs snapshot zroot/root@empty
                '';
              };
            };
          };
          zstorage = {
            type = "zpool";
            mode = "raidz";
            rootFsOptions = {
              canmount = "off";
              checksum = "edonr";
              compression = "zstd";
              dnodesize = "auto";
              mountpoint = "none";
              normalization = "formD";
              relatime = "on";
              "com.sun:auto-snapshot" = "false";
            };
            options = {
              ashift = "12";
              autotrim = "on";
            };
            datasets = {
              reserved = {
                type = "zfs_fs";
                options = {
                  canmount = "off";
                  reservation = "20GiB";
                };
              };
              storage = {
                type = "zfs_fs";
                mountpoint = "/storage";
                options = {
                  atime = "off";
                  canmount = "on";
                  "com.sun:auto-snapshot" = "false";
                };
              };
            };
          };
        };
      };
    }
  ];
}
