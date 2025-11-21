{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-staging.url = "github:nixos/nixpkgs/staging";

    hardware.url = "github:nixos/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland?submodules=1&ref=v0.52.1";
    };
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.52.0";
      inputs.hyprland.follows = "hyprland";
    };
    isd = {
      url = "github:isd-project/isd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # darwin only
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      systems = [
        "x86_64-linux"
        #"x86_64-darwin"
      ];

      lib = nixpkgs.lib.extend (final: _: import ./lib { lib = final; } // home-manager.lib);
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      inherit lib;

      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      overlays = import ./overlays { inherit inputs lib outputs; };
      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        hackstack = lib.nixosSystem {
          modules = [ ./hosts/linux/hackstack ];
          specialArgs = {
            inherit inputs lib outputs;
          };
        };
        laboratory = lib.nixosSystem {
          modules = [ ./hosts/linux/laboratory ];
          specialArgs = {
            inherit inputs lib outputs;
          };
        };
        recreate = lib.nixosSystem {
          modules = [ ./hosts/linux/recreate ];
          specialArgs = {
            inherit inputs lib outputs;
          };
        };

        wsl = lib.nixosSystem {
          modules = [ ./hosts/linux/wsl ];
          specialArgs = {
            inherit inputs lib outputs;
          };
        };
      }
      // (lib.y.workers.eachToAttrs (workerCfg: {
        name = "worker-${workerCfg.shortname}";
        value = lib.nixosSystem {
          modules = [ ./hosts/linux/worker ];
          specialArgs = {
            inherit inputs lib outputs;
            worker = workerCfg;
          };
        };
      }));

      darwinConfigurations = {
        rekorder = nix-darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./hosts/darwin/rekorder ];
          specialArgs = {
            inherit inputs lib outputs;
          };
        };
      };
    };
}
