{
  config,
  lib,
  pkgs,
  ...
}: let
  sourceTmuxConfig = ''
    ${lib.getExe config.programs.tmux.package} -S "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/tmux-1000/default" source-file "${config.home.homeDirectory}/.config/tmux/tmux.conf" || true
  '';

  essentials = config.yeldirs.cli.essentials;
  c = config.colorscheme.colors // config.colorscheme.harmonized;

  defaultTmuxCopyPatterns =
    [
      "([a-f0-9:]+:+)+[a-f0-9]+" # very rudimentary ipv6 regex, taken from https://stackoverflow.com/a/37355379
    ]
    ++ (lib.optionals config.yeldirs.workerSupport [
      "worker-(?<match>[0-9a-f]{5})"
    ]);
in {
  imports = [
    ./plugins/vim-tmux-navigator.nix
  ];

  options = {
    yeldirs.cli.essentials.tmux = {
      autoQuit = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      copyPatterns = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
    };
  };

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

              # =============================================
              # ===   Nesting local and remote sessions   ===
              # =============================================
              # Inspired by and party taken from https://github.com/samoshkin/tmux-config/blob/master/tmux/tmux.conf

              bind -T root F12  \
                set prefix None \;\
                set key-table off \;\
                if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
                set status-style fg=${c.on_surface} \;\
                set -a status-style bg=${c.surface_bright} \;\
                refresh-client -S \;\

              bind -T off F12 \
                set -u prefix \;\
                set -u key-table \;\
                set -u status-style \;\
                refresh-client -S
            '';
          terminal = "tmux-256color";
          plugins = [
            {
              plugin = pkgs.tmuxPlugins.fingers;
              extraConfig =
                lib.imap0
                (index: pattern: "set -g @fingers-pattern-${toString index} '${pattern}'")
                (defaultTmuxCopyPatterns ++ essentials.tmux.copyPatterns)
                |> lib.strings.concatLines;
            }
          ];
        };
      };

      home.packages = with pkgs; [
        (y.shellScript ./scripts/tmhl)
        (y.shellScript ./scripts/tmide)
        (y.shellScript ./scripts/tmnix)
        (y.shellScript ./scripts/tmqmk)
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
          ZSH_TMUX_AUTOQUIT =
            if essentials.tmux.autoQuit
            then "true"
            else "false";
          ZSH_TMUX_DEFAULT_SESSION_NAME = "default";
        };
      };
    })
  ]);
}
