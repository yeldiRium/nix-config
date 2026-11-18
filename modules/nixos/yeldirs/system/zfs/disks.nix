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
  inherit (config.networking) hostName;

  cfg = config.yeldirs.system.disks;
in
{
  options = {
    yeldirs.system.disks = {
      enable = lib.mkEnableOption "standard disk setup using zfs";

      enableImpermance = lib.mkEnableOption "disk impermanence setup using zfs rollback";

      initrd-ssh = {
        enable = lib.mkEnableOption "initrd-ssh";
        ethernetDrivers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            ethernet drivers to load (run "lspci -v | grep -iA8 'network\|ethernet'")
          '';
        };
      };

      zfs = {
        enable = lib.mkEnableOption "zfs";
        arcMax = lib.mkOption {
          type = lib.types.str;
          default = "2147483648";
          description = "maximum size of zfs arc";
        };
        root = {
          encrypt = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          disk = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = ''
              device name for root disk
            '';
          };
          reservation = lib.mkOption {
            type = lib.types.str;
            default = "20GiB";
            description = ''
              zfs reservation
            '';
          };
          impermanenceRoot = lib.mkEnableOption "roll back root on boot";
        };
        storage = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          disks = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = ''
              device names for storage pool
            '';
          };
          mode = lib.mkOption {
            type = lib.types.enum [
              ""
              "mirror"
              "raidz"
            ];
            default = "";
          };
          reservation = lib.mkOption {
            type = lib.types.str;
            default = "20GiB";
            description = ''
              zfs reservation
            '';
          };
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    })
    (lib.mkIf cfg.enable {
      # impermanence
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
    })
    (lib.mkIf (cfg.enable && cfg.initrd-ssh.enable) {
      # setup initrd ssh to unlock the encrypted drive
      boot = {
        kernelParams = [ "ip=::::${hostName}-initrd::dhcp" ];
        initrd = {
          network.enable = true;
          availableKernelModules = cfg.initrd-ssh.ethernetDrivers;
          network.ssh = {
            enable = true;
            port = 22;
            # authorizedKeys = map (key: ''command="systemctl default" ${key}'') authorizedKeys;
            inherit authorizedKeys;
            hostKeys = [ "/etc/ssh/initrd" ];
          };
          secrets = {
            "/etc/ssh/initrd" = "/etc/ssh/initrd";
          };
        };
      };
    })
    (lib.mkIf cfg.zfs.root.impermanenceRoot {
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
    })
    (lib.mkIf (cfg.enable && cfg.zfs.enable) {
      # zfs configuration and devices
      environment.systemPackages = with pkgs; [
        zfs-prune-snapshots
      ];
      boot = {
        # ZFS does not support swapfiles, disable hibernate and set cache max
        kernelParams = [
          "nohibernate"
          "zfs.zfs_arc_max=${cfg.zfs.arcMax}"
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
              device = "/dev/${cfg.zfs.root.disk}";
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
                  luks = lib.mkIf cfg.zfs.root.encrypt {
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
                  notluks = lib.mkIf (!cfg.zfs.root.encrypt) {
                    size = "100%";
                    content = {
                      type = "zfs";
                      pool = "zroot";
                    };
                  };
                };
              };
            };
          }

          (lib.mkIf cfg.zfs.storage.enable
            # hdd raid storage pool
            (
              lib.mkMerge (
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
                }) cfg.zfs.storage.disks
              )
            )
          )
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
              reserved = lib.mkIf (cfg.zfs.root.reservation != "") {
                # zfs gets in trouble when a pool gets too full.
                # shrink this reserved dataset when all the other datasets are
                # at capacity.
                options = {
                  canmount = "off";
                  mountpoint = "none";
                  reservation = "${cfg.zfs.root.reservation}";
                };
                type = "zfs_fs";
              };
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
          zstorage = lib.mkIf cfg.zfs.storage.enable {
            type = "zpool";
            mode = cfg.zfs.storage.mode;
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
                  reservation = cfg.zfs.storage.reservation;
                };
              };
              storage = {
                type = "zfs_fs";
                mountpoint = "/storage";
                options = {
                  mountpoint = "legacy";
                  atime = "off";
                  canmount = "on";
                  "com.sun:auto-snapshot" = "false";
                };
              };
            };
          };
        };
      };

      fileSystems = {
        "/etc/ssh".neededForBoot = true;
        "/nix".neededForBoot = true;
        "/persist".neededForBoot = true;
      };
    })
  ];
}
