{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim;
  reloadNvim = ''
    for server in ''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/nvim.*; do
      ${lib.getExe config.programs.neovim.finalPackage} --server $server --remote-send '<Esc>:source $MYVIMRC<CR>' &
    done
  '';

  optionalAttrs = language: attrs: lib.optionalAttrs (builtins.elem language cfg.supportedLanguages) attrs;
in {
  imports = [
    ./plugins/copilot.nix
    ./plugins/debugging.nix
    ./plugins/early-retirement.nix
    ./plugins/firenvim.nix
    ./plugins/fold-cycle.nix
    ./plugins/harpoon2.nix
    ./plugins/layout.nix
    ./plugins/lsp.nix
    ./plugins/git.nix
    ./plugins/obsidian.nix
    ./plugins/rnvimr.nix
    ./plugins/telescope.nix
    ./plugins/testing.nix
    ./plugins/treesitter.nix
    ./plugins/undotree.nix
  ];

  options = {
    yeldirs.cli.essentials.neovim = {
      enable = lib.mkEnableOption "neovim";

      supportedLanguages = lib.mkOption {
        type = lib.types.listOf (lib.types.enum [
          "bash"
          "docker"
          "go"
          "javascript"
          "json"
          "ledger"
          "lua"
          "markdown"
          "nix"
          "poefilter"
          "typescript"
          "yaml"
        ]);
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.EDITOR = "nvim";

    programs.neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraConfig =
        /*
        vim
        */
        ''
          source ~/.config/nvim/color.vim
        '';

      extraLuaConfig = ''
        ${builtins.readFile ./options.lua}
        ${builtins.readFile ./bindings.lua}
      '';
    };

    xdg.configFile =
      {
        "nvim/init.lua".onChange = reloadNvim;

        "nvim/color.vim".onChange = reloadNvim;
        "nvim/color.vim".source = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
      }
      // optionalAttrs "bash" {
        "nvim/ftplugin/bash.lua".source = pkgs.writeText "bash.lua" (builtins.readFile ./ftplugin/bash.lua);
      }
      // lib.optionalAttrs cfg.git.enable {
        "nvim/ftplugin/NeogitCommitMessage.lua".source = pkgs.writeText "NeogitCommitMessage.lua" (builtins.readFile ./ftplugin/NeogitCommitMessage.lua);
      }
      // optionalAttrs "go" {
        "nvim/ftplugin/go.lua".source = pkgs.writeText "go.lua" (builtins.readFile ./ftplugin/go.lua);
      }
      // optionalAttrs "javascript" {
        "nvim/ftplugin/javascript.lua".source = pkgs.writeText "javascript.lua" (builtins.readFile ./ftplugin/javascript.lua);
      }
      // optionalAttrs "json" {
        "nvim/ftplugin/json.lua".source = pkgs.writeText "json.lua" (builtins.readFile ./ftplugin/json.lua);
      }
      // optionalAttrs "ledger" {
        "nvim/ftplugin/ledger.lua".source = pkgs.writeText "ledger.lua" (builtins.readFile ./ftplugin/ledger.lua);
      }
      // optionalAttrs "lua" {
        "nvim/ftplugin/lua.lua".source = pkgs.writeText "lua.lua" (builtins.readFile ./ftplugin/lua.lua);
      }
      // optionalAttrs "markdown" {
        "nvim/ftplugin/markdown.lua".source = pkgs.writeText "markdown.lua" (builtins.readFile ./ftplugin/markdown.lua);
      }
      // optionalAttrs "nix" {
        "nvim/ftplugin/nix.lua".source = pkgs.writeText "nix.lua" (builtins.readFile ./ftplugin/nix.lua);
      }
      // optionalAttrs "typescript" {
        "nvim/ftplugin/typescript.lua".source = pkgs.writeText "typescript.lua" (builtins.readFile ./ftplugin/typescript.lua);
      };
  };
}
