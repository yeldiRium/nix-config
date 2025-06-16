{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.default
    ./disko.nix

    ../../shared/common/global
    ../../shared/linux/global
  ];

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = "nixos-1";
    hostId = "00000001";
  };
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCf4PuMuh6umz5hvl3u0sT20TP6+EKnOHKjy3uUjYCMjXMtjC83u5TKEl//oZ70g96Kn5w3KEN169ektClvHFJx8nOiZXAI617xVjTkYHtbpDaZOyaPNER23TQ+BNDarhAjtY9RAjgsO0M0wqfg69ElP6+UFl/MM+txjGnf3NasaDto5/bRNIBssBg++FI9xUHW/urD6hddRZ8iBIHxud8qezM9/a6+Q2/5AhBOmJy4MysWea1PP8jA2kbSDjUCNGA4w24pJzyVU8qB8WMWfIkkvUFCSQ/o0UZ133eoEZBGdTMW/oxI/wsUOqyBvbAkpJWPJH4LQqfopLfPjguI5QXj hannes.leutloff@yeldirium.de"
  ];

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
  system.stateVersion = "25.05";
}
