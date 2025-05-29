{
  config,
  lib,
  pkgs,
  ...
}: let
  essentials = config.yeldirs.cli.essentials;
  notifyOfConfigChange = ''
    for server in ''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/nvim.*; do
      ${lib.getExe config.programs.neovim.finalPackage} --server $server --remote-send '<Esc>:lua vim.notify("Your configuration has changed. You might consider restarting neovim.", vim.log.levels.WARN)<CR>' &
    done
  '';
in {
  config = lib.mkIf essentials.enable {
    home.sessionVariables.EDITOR = "nvim";

    programs.neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.unstable.vimPlugins; [
        lazy-nvim

        fidget-nvim
      ];

      extraConfig =
        /*
        vim
        */
        ''
          source ~/.config/nvim/color.vim
        '';

      extraLuaConfig =
        /*
        lua
        */
        ''
          vim.g.mapleader = " "
          require("lazy").setup({
            performance = {
              reset_packpath = false,
              rtp = {
                reset = false,
              }
            },
            dev = {
              path = "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
              patterns = {""}, -- Specify that all of our plugins will use the dev dir. Empty string is a wildcard! https://github.com/folke/lazy.nvim/pull/1676#issuecomment-2248942233
            },
            install = {
              -- Safeguard in case we forget to install a plugin with Nix
              missing = false,
            },
            spec = {
              {
                import = "plugins",
              },
              {
                dir = "${config.xdg.configHome}/nvim/lua/yeldir.nvim",
                main = "yeldir.nvim",
                opts = {},
                dependencies = {
                  "j-hui/fidget.nvim",
                },
                init = function()
                  vim.notify("init yeldir.nvim")
                end,
              },
            },
          })
        '';
    };

    xdg.configFile = {
      "nvim/init.lua".onChange = notifyOfConfigChange;

      "nvim/color.vim".onChange = notifyOfConfigChange;
      "nvim/color.vim".source = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);

      "nvim/lua/plugins/fidget.lua".text = builtins.readFile ./lua/plugins/fidget.lua;
      "nvim/lua/yeldir.nvim" = {
        recursive = true;
        source = ./lua/yeldir.nvim;
      };
    };
  };
}
