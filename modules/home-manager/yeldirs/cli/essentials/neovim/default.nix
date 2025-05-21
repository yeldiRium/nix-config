{
  config,
  lib,
  pkgs,
  ...
}: let
  essentials = config.yeldirs.cli.essentials;
  cfg = config.yeldirs.cli.essentials.neovim;
  reloadNvim = ''
    for server in ''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/nvim.*; do
      ${lib.getExe config.programs.neovim.finalPackage} --server $server --remote-send '<Esc>:source $MYVIMRC<CR>' &
    done
  '';

  optionalAttrs = language: attrs: lib.optionalAttrs (builtins.elem language cfg.supportedLanguages) attrs;
in {
  imports = [
    ./plugins/blamer.nix
    ./plugins/copilot.nix
    ./plugins/debugging.nix
    ./plugins/fidget.nix
    ./plugins/fold-cycle.nix
    ./plugins/git.nix
    ./plugins/quickfilepicker.nix
    ./plugins/illuminate.nix
    ./plugins/layout.nix
    ./plugins/lsp.nix
    ./plugins/obsidian.nix
    ./plugins/oil.nix
    ./plugins/screenkey.nix
    ./plugins/telescope.nix
    ./plugins/testing.nix
    ./plugins/treesitter.nix
    ./plugins/undotree.nix
    ./plugins/vim-tmux-navigator.nix
    ./plugins/which-key.nix
    ./plugins/wsl-clipboard.nix
    ./plugins/yazi.nix
    ./plugins/zoom.nix
  ];

  options = {
    yeldirs.cli.essentials.neovim = {
      supportedLanguages = lib.mkOption {
        type = lib.types.listOf (lib.types.enum [
          "asciidoc"
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
          "rego"
          "rust"
          "typescript"
          "yaml"
        ]);
      };
    };
  };

  config = lib.mkIf essentials.enable {
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
        ${builtins.readFile ./autocommands/restore-cursor-position.lua}
      '';
    };

    xdg.configFile =
      {
        "nvim/init.lua".onChange = reloadNvim;

        "nvim/color.vim".onChange = reloadNvim;
        "nvim/color.vim".source = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
      }
      // optionalAttrs "asciidoc" {
        "nvim/ftplugin/asciidoc.lua".source = pkgs.writeText "asciidoc.lua" (builtins.readFile ./ftplugin/asciidoc.lua);
      }
      // optionalAttrs "bash" {
        "nvim/ftplugin/bash.lua".source = pkgs.writeText "bash.lua" (builtins.readFile ./ftplugin/bash.lua);
      }
      // optionalAttrs cfg.git.enable {
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
      // optionalAttrs "rust" {
        "nvim/ftplugin/rust.lua".source = pkgs.writeText "rust.lua" (builtins.readFile ./ftplugin/rust.lua);
      }
      // optionalAttrs "typescript" {
        "nvim/ftplugin/typescript.lua".source = pkgs.writeText "typescript.lua" (builtins.readFile ./ftplugin/typescript.lua);
      };
  };
}
