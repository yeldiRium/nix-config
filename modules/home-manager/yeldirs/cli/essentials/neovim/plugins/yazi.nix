{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.yazi;
in {
  options = {
    yeldirs.cli.essentials.neovim.yazi.enable = lib.mkEnableOption "neovim plugin yazi";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = yazi-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local yazi = require("yazi")
            yazi.setup({
              open_for_directories = true,
            })

            vim.keymap.set("n", "<leader>fy", function() yazi.yazi() end, { desc = "Yazi" })

            vim.g.loaded_netrwPlugin = 1
          '';
      }
    ];
  };
}
