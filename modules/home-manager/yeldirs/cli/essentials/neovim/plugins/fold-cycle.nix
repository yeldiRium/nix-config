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

            vim.keymap.set("n", "<M-Up>", "zc", { desc = "Close fold under cursor." })
            vim.keymap.set("n", "<M-S-Up>", foldCycle.close_all, { desc = "Close folds under cursor recursively." })
            vim.keymap.set("n", "<M-C-Up>", "zM", { desc = "Close all folds." })
            vim.keymap.set("n", "<M-Down>", "zo", { desc = "Open fold under cursor." })
            vim.keymap.set("n", "<M-S-Down>", foldCycle.open_all, { desc = "Open folds under cursor recursively." })
            vim.keymap.set("n", "<M-C-Down>", "zR", { desc = "Open all folds." })
          '';
      }
    ];
  };
}
