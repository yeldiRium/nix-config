{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.neovim.git;
in {
  options = {
    yeldirs.cli.neovim.git.enable = lib.mkEnableOption "neovim git support";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.neovim.enable;
        message = "neovim must be enabled for the git support to work";
      }
    ];

    home.packages = with pkgs; [
      git
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      nvim-web-devicons
      diffview-nvim
      {
        plugin = neogit;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local neogit = require('neogit')
            neogit.setup({})

            vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>")
          '';
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local gitsigns = require("gitsigns")
            gitsigns.setup({})
          '';
      }
    ];
  };
}
