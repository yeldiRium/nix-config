{inputs, ...}: {
  imports = [
    inputs.mac-app-util.darwinModules.default
    inputs.home-manager.darwinModules.default

    ./nix.nix
  ];
}
