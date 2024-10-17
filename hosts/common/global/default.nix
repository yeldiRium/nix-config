{
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default

    ./locale.nix
    ./nix-ld.nix
    ./nix.nix
    ./persistence.nix
    ./sops.nix
    ./steam-hardware.nix
    ./upower.nix
    ./zsh.nix
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

  hardware.enableRedistributableFirmware = true;
}
