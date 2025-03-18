{
  config,
  lib,
  pkgs,
  ...
}: let
  shellScript = import ../../../../../../lib/shellScript.nix pkgs;

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
        extraConfig =
          /*
          tmux
          */
          ''
            set -g mouse on

            set -g status-style fg=${c.on_primary_container}
            set -ag status-style bg=${c.primary_container}

            set -g monitor-bell on
            set -g window-status-bell-style fg=${c.on_tertiary_container}
            set -ag window-status-bell-style bg=${c.tertiary_container}

            set -g pane-border-lines double
            set -g pane-border-style fg=${c.outline}
            set -g pane-active-border-style fg=${c.primary_container}
          '';
        terminal = "tmux-256color";
      };
    };

    home.packages = [
      (shellScript ./scripts/tm)
      (shellScript ./scripts/tmhl)
      (shellScript ./scripts/tmnix)
      (shellScript ./scripts/tmqmk)
    ];
  };
}
