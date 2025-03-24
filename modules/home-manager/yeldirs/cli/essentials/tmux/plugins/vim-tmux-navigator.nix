{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.tmux.vim-tmux-navigator;
in {
  options = {
    yeldirs.cli.essentials.tmux.vim-tmux-navigator = {
      enable = lib.mkEnableOption "tmux plugin vim-tmux-navigator";
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
        assertion = config.yeldirs.cli.essentials.neovim.vim-tmux-navigator.enable;
        message = "the neovim plugin vim-tmux-navigator must be enabled for the neovim plugin vim-tmux-navigator to work";
      }
    ];

    programs.tmux.plugins = [
      {
        plugin = pkgs.tmuxExtraPlugins.vim-tmux-navigator;
        extraConfig =
          /*
          tmux
          */
          ''
            set -g @vim_navigator_mapping_left "C-Left"
            set -g @vim_navigator_mapping_right "C-Right"
            set -g @vim_navigator_mapping_up "C-Up"
            set -g @vim_navigator_mapping_down "C-Down"
            set -g @vim_navigator_mapping_prev ""  # removes the C-\ binding

            unbind -T prefix Left
            unbind -T prefix Right
            unbind -T prefix Up
            unbind -T prefix Down
          '';
      }
    ];
  };
}
