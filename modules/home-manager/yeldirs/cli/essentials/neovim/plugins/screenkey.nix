{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.screenkey;
in {
  options = {
    yeldirs.cli.essentials.neovim.screenkey.enable = lib.mkEnableOption "neovim plugin screenkey";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.vimExtraPlugins; [
      {
        plugin = screenkey-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local screenkey = require("screenkey")
            screenkey.setup({})

            vim.keymap.set("n", "<leader>ls", function()
              vim.cmd("Screenkey toggle")
            end, { desc = "Toggle screenkey" })
          '';
      }
    ];
  };
}
