{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "kitty";

    # Window management bindings
    bind =
      [
        "$mod SHIFT, Q, exit" # Exits out of hyprland
        "$mod, Q, killactive" # Closes the focused window
        "$mod, X, killactive" # Closes the focused window

        # navigate around windows
        "$mod, left, movefocus, l"
        "$mod, I, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, E, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, L, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, A, movefocus, d"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, I, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, E, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, L, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod SHIFT, A, movewindow, d"

        # adjust layout
        "$mod, Space, togglefloating"
        "$mod, T, togglegroup"
        "$mod, F, fullscreen"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (
            i: let
              ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      )
      ++
      # Important applications with shortcuts
      [
        "$mod, Return, exec, $terminal" # Launches a terminal
      ]
      ++
      # Launch programs with rofi
      (
        let
          rofi = lib.getExe config.programs.rofi.package;
        in
          lib.optionals config.programs.rofi.enable [
            "$mod SHIFT, D, exec, ${rofi} -show run"
            "$mod, D, exec, ${rofi} -show combi -modes combi -combi-modes \"window,drun\""
          ]
          ++ (
            let
              cliphist = lib.getExe config.services.cliphist.package;
            in
              lib.optionals config.services.cliphist.enable [
                ''SUPER, C, exec, selected=$(${cliphist} list | ${rofi} -dmenu) && echo "$selected" | ${cliphist} decode | wl-copy''
              ]
          )
      )
      ++
      # Lock screen with swaylock
      (
        let
          swaylock = lib.getExe config.programs.swaylock.package;
        in
          lib.optionals config.programs.swaylock.enable [
            "$mod, G, exec, ${swaylock} --screenshots --grace 2 --grace-no-mouse"
            "$mod, XF86ScreenSaver, exec, ${swaylock} --screenshots --grace 2 --grace-no-mouse"
          ]
      )
      ++
      # Notification manager
      (
        let
          makoctl = lib.getExe' config.services.mako.package "makoctl";
        in
          lib.optionals config.services.mako.enable [
            "SUPER, w, exec, ${makoctl} dismiss"
            "SUPERSHIFT, w, exec, ${makoctl} restore"
          ]
      )
      ++
      # Volume control
      (let
        pactl = lib.getExe' pkgs.pulseaudio "pactl";
      in [
        "    , XF86AudioRaiseVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
        "    , XF86AudioLowerVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
        "    , XF86AudioMute, exec, ${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
        "SHIFT, XF86AudioRaiseVolume, exec, ${pactl} set-source-volume @DEFAULT_SOURCE@ +5%"
        "SHIFT, XF86AudioLowerVolume, exec, ${pactl} set-source-volume @DEFAULT_SOURCE@ -5%"
        "SHIFT, XF86AudioMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
        "    , XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
      ])
      ++
      # Playerctl
      (
        let
          playerctl = lib.getExe' config.services.playerctld.package "playerctl";
          playerctld = lib.getExe' config.services.playerctld.package "playerctld";
        in
          lib.optionals config.services.playerctld.enable [
            # Media control
            ",XF86AudioNext,exec,${playerctl} next"
            ",XF86AudioPrev,exec,${playerctl} previous"
            ",XF86AudioPlay,exec,${playerctl} play-pause"
            ",XF86AudioStop,exec,${playerctl} stop"
            "SHIFT,XF86AudioNext,exec,${playerctld} shift"
            "SHIFT,XF86AudioPrev,exec,${playerctld} unshift"
            "SHIFT,XF86AudioPlay,exec,systemctl --user restart playerctld"
          ]
      )
      ++
      # Screenshotting
      (let
        grimblast = lib.getExe pkgs.grimblast;
      in [
        "    , Print, exec, ${grimblast} --notify --freeze copy area"
        "SHIFT, Print, exec, ${grimblast} --notify --freeze copy output"
      ])
      ++
      # Brightness control (only works if the system has lightd)
      [
        "    , XF86MonBrightnessUp, exec, light -A 10"
        "    , XF86MonBrightnessDown, exec, light -U 10"
      ];
  };
}
