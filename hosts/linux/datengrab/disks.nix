{
  config,
  lib,
  pkgs,
  ...
}:
let
  storageDisks = [
    "sda"
    "sdb"
    "sdd"
    "sde"
  ];
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

      # needed for impermanence
      fileSystems."/persist".neededForBoot = true;
      fileSystems."/nix".neededForBoot = true;

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
          "nfs"
          "zfs"
          "ntfs"
          "ext4"
          "exfat"
          "vfat"
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
                  root = {
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

          # hdd raid storage pool
          (lib.mkMerge (
            map (diskname: {
              "${diskname}" = {
                type = "disk";
                device = "/dev/${diskname}";
                content = {
                  type = "gpt";
                  partitions = {
                    storage = {
                      size = "100%";
                      content = {
                        type = "zfs";
                        pool = "zstorage";
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
                options = {
                  canmount = "off";
                  mountpoint = "none";
                  reservation = "20GiB";
                };
                type = "zfs_fs";
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
