{
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default

    ./backup.nix
    ./filesystems.nix
    ./locale.nix
    ./nix-ld.nix
    ./nix.nix
    ./persistence.nix
    ./printing.nix
    ./sops.nix
    ./upower.nix
    ./zsh.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
