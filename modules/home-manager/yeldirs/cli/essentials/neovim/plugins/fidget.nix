{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli) essentials;
in
{
  config = lib.mkIf essentials.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = fidget-nvim;
        type = "lua";
        config =
          # lua
          ''
            local fidget = require("fidget")
            fidget.setup({
              notification = {
                override_vim_notify = true,
              },
            })

            vim.keymap.set("n", "<leader>nn", function()
              fidget.notification.show_history()
            end, { desc = "Show notification history" })
          '';
      }
    ];
  };
}
