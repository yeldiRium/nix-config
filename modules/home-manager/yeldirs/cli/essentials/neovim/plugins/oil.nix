{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials.neovim.oil;
in
{
  options = {
    yeldirs.cli.essentials.neovim.oil.enable = lib.mkEnableOption "neovim plugin oil";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = mini-icons;
        type = "lua";
        config =
          # lua
          ''
            require("mini.icons").setup()
          '';
      }
      {
        plugin = oil-nvim;
        type = "lua";
        config =
          # lua
          ''
            local oil = require("oil")

            local oilDetailView = false
            oil.setup({
              keymaps = {
                ["gd"] = {
                  desc = "Toggle file detail view",
                  callback = function()
                    oilDetailView = not oilDetailView
                    if oilDetailView then
                      require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                    else
                      require("oil").set_columns({ "icon" })
                    end
                  end,
                },
              },
              view_options = {
                show_hidden = true,
              },
            })

            vim.keymap.set("n", "-", function()
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
