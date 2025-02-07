{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.git;
in {
  options = {
    yeldirs.cli.essentials.neovim.git.enable = lib.mkEnableOption "neovim git support";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the git support to work";
      }
      {
        assertion = config.yeldirs.cli.essentials.git.enable;
        message = "git must be enabled for the neovim git support to work";
      }
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
