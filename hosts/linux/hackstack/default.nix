{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    inputs.disko.nixosModules.default
    (import ./disko.nix {device = "/dev/nvme0n1";})

    ../../shared/common/global
    ../../shared/linux/global

    ../../shared/linux/optional/bluetooth.nix
    ../../shared/linux/optional/greetd.nix
    ../../shared/linux/optional/networkmanager.nix
    ../../shared/linux/optional/persistence.nix
    ../../shared/linux/optional/pipewire.nix
    ../../shared/linux/optional/printing.nix
    ../../shared/linux/optional/upower.nix

    ../../shared/linux/optional/mounts/datengrab.nix

    ../../shared/linux/users/yeldir
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
  ];

  networking = {
    hostName = "hackstack";
    hostId = "963c546b";
  };

  yeldirs = {
    common.global.sops.enable = true;
    mounts = {
      datengrab.enable = true;
    };
  };

  programs = {
    dconf.enable = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
