{inputs, ...}: {
  imports = [
    inputs.mac-app-util.darwinModules.default

    ./nix.nix
  ];
}
