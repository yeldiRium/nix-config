{ outputs, ... }:
{
  imports = builtins.attrValues outputs.nixosModules ++ [
    ./locale.nix
    ./nix.nix
    ./nix-ld.nix
    ./permissions.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
