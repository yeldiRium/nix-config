{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.system;
        config.allowUnfree = true;
      };
    };
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ({...}: {nixpkgs.overlays = [overlay-unstable];})
        inputs.disko.nixosModules.default
        (import ./disko.nix {device = "/dev/sda";})

        ./configuration.nix

        inputs.home-manager.nixosModules.default
        inputs.impermanence.nixosModules.impermanence
      ];
    };
  };
}
