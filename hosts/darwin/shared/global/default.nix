{ inputs, outputs, ... }:
{
  imports = builtins.attrValues outputs.darwinModules ++ [
    inputs.mac-app-util.darwinModules.default

    ./nix.nix
  ];
}
