{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials.neovim.fold-cycle;
in
{
  options = {
    yeldirs.cli.essentials.neovim.fold-cycle.enable = lib.mkEnableOption "neovim plugin fold-cycle";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.vimExtraPlugins; [
      {
        plugin = fold-cycle-nvim;
        type = "lua";
        config =
          # lua
          ''
            local foldCycle = require("fold-cycle")
            foldCycle.setup({})

            vim.keymap.set("n", "zC", foldCycle.close_all, { desc = "Close folds under cursor recursively." })
            vim.keymap.set("n", "zO", foldCycle.open_all, { desc = "Open folds under cursor recursively." })
          '';
      }
    ];
  };
}
