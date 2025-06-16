{
  imports = [
    ./filesystems.nix
    ./locale.nix
    ./nix.nix
    ./nix-ld.nix
    ./printing.nix
    ./sops.nix
    ./upower.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
