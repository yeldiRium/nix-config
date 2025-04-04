{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.vim-tmux-navigator;
in {
  options = {
    yeldirs.cli.essentials.neovim.vim-tmux-navigator = {
      enable = lib.mkEnableOption "neovim plugin vim-tmux-navigator";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for vim-tmux-navigator to work";
      }
      {
        assertion = config.yeldirs.cli.essentials.tmux.enable;
        message = "tmux must be enabled for vim-tmux-navigator to work";
      }
      {
        assertion = config.yeldirs.cli.essentials.tmux.vim-tmux-navigator.enable;
        message = "the tmux plugin vim-tmux-navigator must be enabled for the neovim plugin vim-tmux-navigator to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = vim-tmux-navigator;
        type = "lua";
        config =
          /*
          lua
          */
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
