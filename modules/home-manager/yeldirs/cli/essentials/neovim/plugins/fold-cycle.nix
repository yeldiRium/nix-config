{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.fold-cycle;
in {
  options = {
    yeldirs.cli.essentials.neovim.fold-cycle.enable = lib.mkEnableOption "neovim plugin fold-cycle";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the plugin fold-cycle to work";
      }
    ];

    programs.neovim.plugins = with pkgs.vimExtraPlugins; [
      {
        plugin = fold-cycle-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local foldCycle = require("fold-cycle")
            foldCycle.setup({})

            vim.keymap.set("n", "<M-Up>", function()
              foldCycle.close()
            end,
            { desc = "Close fold under cursor." })
            vim.keymap.set("n", "<M-Down>", function()
              foldCycle.open()
            end,
            { desc = "Open fold under cursor." })
          '';
      }
    ];
  };
}
