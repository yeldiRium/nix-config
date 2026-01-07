{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

      # see :help nixCats.flake.outputs.overlays
      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
        (final: _: import ../../pkgs { pkgs = final; })
      ];

      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions =
        {
          pkgs,
          ...
        }:
        {
          lspsAndRuntimeDeps = {
            general = with pkgs; [
              tree-sitter
            ];

            languages = {
              go = with pkgs; [
                gopls
                y.golangci-lint-langserver
              ];
            };
          };

          startupPlugins = {
            general = with pkgs.vimPlugins; [
              # TODO: install parsers and queries via nix.
              # Currently they are installed and managed via nvim-treesitter.
              # I want to change that so that no packages are ever installed via network outside of nix builds.
              nvim-treesitter

              telescope-ui-select-nvim
              telescope-fzf-native-nvim
              telescope-nvim
            ];
            languages = {
              go = with pkgs.vimPlugins; [
              ];
            };
          };

          # TODO: lazy load plugins
          optionalPlugins = { };
        };

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = {
        neovim = _: {
          # see :help nixCats.flake.outputs.settings
          settings = {
            wrapRc = true;
            aliases = [
              "nvim"
              "vim"
              "vi"
            ];
          };
          categories = {
            general = true;
            languages = {
              go = true;
            };
          };
        };
      };

      defaultPackageName = "neovim";
    in

    # see :help nixCats.flake.outputs.exports
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;
      }
    );
}
