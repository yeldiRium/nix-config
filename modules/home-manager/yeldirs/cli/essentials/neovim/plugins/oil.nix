{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.oil;
in {
  options = {
    yeldirs.cli.essentials.neovim.oil.enable = lib.mkEnableOption "neovim plugin oil";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = mini-icons;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("mini.icons").setup()
          '';
      }
      {
        plugin = oil-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            oil = require("oil")
            oil.setup({
              columns = {
                "icon",
                "permissions",
                "size",
                "mtime",
              },
              view_options = {
                show_hidden = true,
              },
            })

            vim.keymap.set("n", "<leader>fo", function()
              oil.open(
                nil,
                {
                  preview = {
                    vertical = true,
                  },
                }
              )
            end, { desc = "Open oil file browser" })
          '';
      }
    ];
  };
}
