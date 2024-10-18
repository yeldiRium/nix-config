{
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default

    ./filesystems.nix
    ./locale.nix
    ./nix-ld.nix
    ./nix.nix
    ./persistence.nix
    ./printing.nix
    ./sops.nix
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
