{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  system.stateVersion = "24.05"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    git
  ];

  users.users."yeldir" = {
    isNormalUser = true;
    initialPassword = "12345";
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp

    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
      rm -rf /btrfs_tmp/root
      btrfs subvolume delete /btrfs_tmp/root
    fi

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
}
