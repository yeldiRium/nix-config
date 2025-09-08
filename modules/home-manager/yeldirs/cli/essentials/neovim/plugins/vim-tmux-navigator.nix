{
  config,
  lib,
  pkgs,
  ...
}:
let
  essentials = config.yeldirs.cli.essentials;
in
{
  config = lib.mkIf essentials.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = vim-tmux-navigator;
        type = "lua";
        config =
          # lua
          ''
            vim.g["tmux_navigator_no_mappings"] = 1

            vim.keymap.set("n", "<C-Left>", ":<C-U>TmuxNavigateLeft<cr>", { desc = "Move focus to the window or tmux pane to the left" })
            vim.keymap.set("n", "<C-Down>", ":<C-U>TmuxNavigateDown<cr>", { desc = "Move focus to the window or tmux pane to the right" })
            vim.keymap.set("n", "<C-Up>", ":<C-U>TmuxNavigateUp<cr>", { desc = "Move focus to the window or tmux pane at the top" })
            vim.keymap.set("n", "<C-Right>", ":<C-U>TmuxNavigateRight<cr>", { desc = "Move focus to the window or tmux pane at the bottom" })
          '';
      }
    ];
  };
}
