{
  imports = [
    ./filesystems.nix
    ./locale.nix
    ./nix.nix
    ./nix-ld.nix
    ./sops.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
