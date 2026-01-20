{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli) essentials;
  cfg = config.yeldirs.cli.essentials.neovim;
  notifyOfConfigChange = ''
    for server in ''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/nvim.*; do
      ${lib.getExe config.programs.neovim.finalPackage} --server $server --remote-send '<Esc>:lua vim.notify("Your configuration has changed. You might consider restarting neovim.", vim.log.levels.WARN)<CR>' &
    done
  '';

  forLanguage =
    language: attrs: lib.optionalAttrs (builtins.elem language cfg.supportedLanguages) attrs;
in
{
  imports = [
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
    ./plugins/symbols.nix
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
        type = lib.types.listOf (
          lib.types.enum [
            "asciidoc"
            "bash"
            "css"
            "docker"
            "go"
            "html"
            "javascript"
            "json"
            "ledger"
            "lua"
            "markdown"
            "nix"
            "poefilter"
            "python"
            "rego"
            "rust"
            "tofu"
            "typescript"
            "yaml"
          ]
        );
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
        # vim
        ''
          source ~/.config/nvim/color.vim
        '';

      extraLuaConfig = ''
        ${builtins.readFile ./options.lua}
        ${builtins.readFile ./bindings.lua}
        ${builtins.readFile ./autocommands/restore-cursor-position.lua}
        ${builtins.readFile ./lua/filetype-shebang.lua}
      '';
    };

    xdg.configFile = {
      "nvim/init.lua".onChange = notifyOfConfigChange;

      "nvim/color.vim".onChange = notifyOfConfigChange;
      "nvim/color.vim".source = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
    }
    // forLanguage "asciidoc" {
      "nvim/ftplugin/asciidoc.lua".source = pkgs.writeText "asciidoc.lua" (
        builtins.readFile ./ftplugin/asciidoc.lua
      );
    }
    // forLanguage "bash" {
      "nvim/ftplugin/bash.lua".source = pkgs.writeText "bash.lua" (builtins.readFile ./ftplugin/bash.lua);
    }
    // forLanguage "css" {
      "nvim/ftplugin/css.lua".source = pkgs.writeText "css.lua" (builtins.readFile ./ftplugin/css.lua);
    }
    // lib.optionalAttrs cfg.git.enable {
      "nvim/ftplugin/NeogitCommitMessage.lua".source = pkgs.writeText "NeogitCommitMessage.lua" (
        builtins.readFile ./ftplugin/NeogitCommitMessage.lua
      );
    }
    // forLanguage "go" {
      "nvim/ftplugin/go.lua".source = pkgs.writeText "go.lua" (builtins.readFile ./ftplugin/go.lua);
    }
    // forLanguage "html" {
      "nvim/ftplugin/html.lua".source = pkgs.writeText "html.lua" (builtins.readFile ./ftplugin/html.lua);
    }
    // forLanguage "javascript" {
      "nvim/ftplugin/javascript.lua".source = pkgs.writeText "javascript.lua" (
        builtins.readFile ./ftplugin/javascript.lua
      );
    }
    // forLanguage "json" {
      "nvim/ftplugin/json.lua".source = pkgs.writeText "json.lua" (builtins.readFile ./ftplugin/json.lua);
    }
    // forLanguage "ledger" {
      "nvim/ftplugin/ledger.lua".source = pkgs.writeText "ledger.lua" (
        builtins.readFile ./ftplugin/ledger.lua
      );
    }
    // forLanguage "lua" {
      "nvim/ftplugin/lua.lua".source = pkgs.writeText "lua.lua" (builtins.readFile ./ftplugin/lua.lua);
    }
    // forLanguage "markdown" {
      "nvim/ftplugin/markdown.lua".source = pkgs.writeText "markdown.lua" (
        builtins.readFile ./ftplugin/markdown.lua
      );
    }
    // forLanguage "nix" {
      "nvim/ftplugin/nix.lua".source = pkgs.writeText "nix.lua" (builtins.readFile ./ftplugin/nix.lua);
    }
    // forLanguage "rust" {
      "nvim/ftplugin/rust.lua".source = pkgs.writeText "rust.lua" (builtins.readFile ./ftplugin/rust.lua);
    }
    // forLanguage "tofu" {
      "nvim/ftplugin/alloy.lua".source = pkgs.writeText "alloy.lua" (
        builtins.readFile ./ftplugin/alloy.lua
      );
      "nvim/ftplugin/hcl.lua".source = pkgs.writeText "hcl.lua" (builtins.readFile ./ftplugin/hcl.lua);
      "nvim/ftplugin/opentofu.lua".source = pkgs.writeText "opentofu.lua" (
        builtins.readFile ./ftplugin/opentofu.lua
      );
      "nvim/ftplugin/tofu.lua".source = pkgs.writeText "tofu.lua" (builtins.readFile ./ftplugin/tofu.lua);
    }
    // forLanguage "typescript" {
      "nvim/ftplugin/typescript.lua".source = pkgs.writeText "typescript.lua" (
        builtins.readFile ./ftplugin/typescript.lua
      );
    };
  };
}
