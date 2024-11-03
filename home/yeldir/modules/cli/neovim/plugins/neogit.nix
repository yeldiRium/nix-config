{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.neovim.neogit;
in {
  options = {
    yeldirs.cli.neovim.neogit.enable = lib.mkEnableOption "neovim plugin neogit";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.neovim.enable;
        message = "neovim must be enabled for the plugin neogit to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
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
    ];
  };
}
