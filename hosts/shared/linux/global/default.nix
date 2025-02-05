{
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default

    ./backup.nix
    ./filesystems.nix
    ./locale.nix
    ./nix.nix
    ./nix-ld.nix
    ./printing.nix
    ./upower.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
