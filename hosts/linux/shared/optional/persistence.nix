{
  config,
  lib,
  ...
}:
{
  # This requires that a volume group named `root_vg` exists.
  # Achive this by importing a disko.nix in the host and giving it the correct device name.

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
      rm -rf /btrfs_tmp/root
      btrfs subvolume delete /btrfs_tmp/root
    fi

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  fileSystems."/persist".neededForBoot = true;
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
        {
          file = "/var/keys/secret_file";
          parentDirectory = {
            mode = "u=rwx,g=,o=";
          };
        }
      ];
    };
  };
  programs.fuse.userAllowOther = true;

  # https://app.semanticdiff.com/gh/NixOS/nixpkgs/pull/351151/overview
  boot.initrd.systemd.suppressedUnits = [ "systemd-machine-id-commit.service" ];
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

  system.activationScripts.persistent-dirs.text =
    let
      mkHomePersist =
        user:
        lib.optionalString user.createHome ''
               	mkdir -p /persist/${user.home}
          chown ${user.name}:${user.group} /persist/${user.home}
          chmod ${user.homeMode} /persist/${user.home}
        '';
      users = lib.attrValues config.users.users;
    in
    lib.concatLines (map mkHomePersist users);
}
