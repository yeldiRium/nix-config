{outputs, ...}: {
  imports = builtins.attrValues outputs.nixosModules ++ [
    ./filesystems.nix
    ./locale.nix
    ./nix.nix
    ./nix-ld.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
