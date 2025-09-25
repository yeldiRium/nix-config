{ outputs, ... }:
{
  imports = builtins.attrValues outputs.nixosModules ++ [
    ./filesystems.nix
    ./locale.nix
    ./nix.nix
    ./nix-ld.nix
    ./permissions.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
