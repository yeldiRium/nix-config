{
  config,
  lib,
  pkgs,
  ...
}: let
  shellScript = import ../../../../../../lib/shellScript.nix pkgs;

  sourceTmuxConfig = ''
    ${lib.getExe config.programs.tmux.package} -S "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/tmux-1000/default" source-file "${config.home.homeDirectory}/.config/tmux/tmux.conf" || true
  '';

  essentials = config.yeldirs.cli.essentials;
  c = config.colorscheme.colors // config.colorscheme.harmonized;
in {
  imports = [
    ./plugins/vim-tmux-navigator.nix
  ];

  config = lib.mkIf essentials.enable (lib.mkMerge [
    {
      programs = {
        tmux = {
          enable = true;
          package = pkgs.unstable.tmux;
          clock24 = true;
          keyMode = "vi";
          shortcut = "n";
          escapeTime = 0;
          historyLimit = 10000;
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

              bind-key -T prefix '"' split-window -v -c "#{pane_current_path}"
              bind-key -T prefix % split-window -h -c "#{pane_current_path}"

            '';
          terminal = "tmux-256color";
        };
      };

      home.packages = [
        (shellScript ./scripts/tmhl)
        (shellScript ./scripts/tmide)
        (shellScript ./scripts/tmnix)
        (shellScript ./scripts/tmqmk)
      ];

      xdg.configFile = {
        "tmux/tmux.conf".onChange = sourceTmuxConfig;
      };
    }
    (lib.mkIf (config.programs.zsh.enable) {
      programs.zsh = {
        oh-my-zsh.plugins = [
          "tmux"
        ];
        sessionVariables = {
          ZSH_TMUX_AUTOSTART = "true";
          ZSH_TMUX_AUTOQUIT = "false";
          ZSH_TMUX_DEFAULT_SESSION_NAME = "default";
        };
      };
    })
  ]);
}
