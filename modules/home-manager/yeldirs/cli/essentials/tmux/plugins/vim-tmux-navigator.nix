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
    programs.tmux.plugins = [
      {
        plugin = pkgs.tmuxExtraPlugins.vim-tmux-navigator;
        extraConfig =
          # tmux
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
