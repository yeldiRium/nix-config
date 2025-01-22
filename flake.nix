{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # darwin only
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
      #"x86_64-darwin"
    ];

    lib = nixpkgs.lib // home-manager.lib;
    forAllSystems = nixpkgs.lib.genAttrs systems;
    pkgsFor = lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;

    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs lib outputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      hackstack = lib.nixosSystem {
        modules = [./hosts/hackstack];
        specialArgs = {
          inherit inputs outputs;
        };
      };
      laboratory = lib.nixosSystem {
        modules = [./hosts/laboratory];
        specialArgs = {
          inherit inputs outputs;
        };
      };
      recreate = lib.nixosSystem {
        modules = [./hosts/recreate];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };

    darwinConfigurations = {
      rekorder = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [./hosts/darwin/rekorder];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };

    homeConfigurations = {
      "yeldir@hackstack" = lib.homeManagerConfiguration {
        modules = [./home/yeldir/hackstack.nix ./home/yeldir/nixpkgs.nix];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
      "yeldir@laboratory" = lib.homeManagerConfiguration {
        modules = [./home/yeldir/laboratory.nix ./home/yeldir/nixpkgs.nix];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
      "yeldir@recreate" = lib.homeManagerConfiguration {
        modules = [./home/yeldir/recreate.nix ./home/yeldir/nixpkgs.nix];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}
