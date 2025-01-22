{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.mac-app-util.darwinModules.default
    inputs.home-manager.darwinModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs outputs;};
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
}
