{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.tmux;
  c = config.colorscheme.colors // config.colorscheme.harmonized;
in {
  options = {
    yeldirs.cli.essentials.tmux = {
      enable = lib.mkEnableOption "tmux";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      tmux = {
        enable = true;
        clock24 = true;
        keyMode = "vi";
        shortcut = "n";
        escapeTime = 0;
        extraConfig = ''
          set -g mouse on
          set -g status-style fg=${c.on_primary_container}
          set -ag status-style bg=${c.primary_container}
        '';
        terminal = "tmux-256color";
      };
    };
  };
}
