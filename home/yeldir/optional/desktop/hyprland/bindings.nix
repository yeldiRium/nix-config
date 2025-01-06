{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "kitty";

    bind = let
      keys = {
        "1" = "exclam";
        "2" = "quotedbl";
        "3" = "section";
        "4" = "dollar";
        "5" = "percent";
        "6" = "ampersand";
        "7" = "slash";
        "8" = "parenleft";
        "9" = "parenright";
      };
      workspaces = builtins.attrNames keys;
      key = n: n;
      shiftKey = n: keys.${n};

      directions = rec {
        left = "l";
        right = "r";
        up = "u";
        down = "d";
        I = left;
        E = right;
        L = up;
        A = down;
      };
    in
      (
        # Go to workspace
        map (n: "$mod, ${key n}, workspace, ${n}") workspaces
      )
      ++ (
        # Move window to workspace
        map (n: "$mod SHIFT, ${shiftKey n}, hy3:movetoworkspace, ${n}") workspaces
      )
      ++
      # Move focus
      (lib.mapAttrsToList (key: direction: "$mod, ${key}, hy3:movefocus, ${direction}") directions)
      ++
      # Move windows
      (lib.mapAttrsToList (key: direction: "$mod SHIFT, ${key}, hy3:movewindow, ${direction}") directions)
      ++ [
        # Move workspace to other monitor
        "$mod SHIFT, U, movecurrentworkspacetomonitor, l"
        "$mod SHIFT, home, movecurrentworkspacetomonitor, l"
        "$mod SHIFT, O, movecurrentworkspacetomonitor, r"
        "$mod SHIFT, end, movecurrentworkspacetomonitor, r"
      ]
      ++ [
        # Window management bindings

        "$mod SHIFT, Q, exit" # Exits out of hyprland
        "$mod, Q, hy3:killactive" # Closes the focused window
        "$mod, X, hy3:killactive" # Closes the focused window

        # adjust layout
        "$mod, Space, togglefloating"
        "$mod, F, fullscreen"
        "$mod, T, hy3:makegroup, tab"
        "$mod, V, hy3:makegroup, v"
        "$mod, H, hy3:makegroup, h"
        "$mod, S, hy3:changefocus, raise"
        "$mod SHIFT, S, hy3:changefocus, lower"
      ]
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
            "$mod, Tab, exec, ${rofi} -show window"
            "$mod, D, exec, ${rofi} -show drun"
          ]
          ++ (
            let
              cliphist = lib.getExe config.services.cliphist.package;
            in
              lib.optionals config.services.cliphist.enable [
                ''$mod, C, exec, selected=$(${cliphist} list | ${rofi} -dmenu) && echo "$selected" | ${cliphist} decode | wl-copy''
              ]
          )
      )
      ++
      # Lock screen with swaylock
      (
        let
          swaylock = lib.getExe config.programs.swaylock.package;
          swaylockCmd = "${swaylock} --screenshots --grace 2 --grace-no-mouse";
        in
          lib.optionals config.programs.swaylock.enable [
            "$mod, G, exec, ${swaylockCmd}"
            "$mod, XF86ScreenSaver, exec, ${swaylockCmd}"
          ]
      )
      ++
      # Notification manager
      (
        let
          makoctl = lib.getExe' config.services.mako.package "makoctl";
        in
          lib.optionals config.services.mako.enable [
            "$mod, W, exec, ${makoctl} dismiss"
            "$mod SHIFT, W, exec, ${makoctl} restore"
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
        "$mod      , M, exec, ${grimblast} --notify --freeze copy area"
        "$mod SHIFT, M, exec, ${grimblast} --notify --freeze copy output"
      ])
      ++
      # Brightness control (only works if the system has lightd)
      [
        "    , XF86MonBrightnessUp, exec, light -A 10"
        "    , XF86MonBrightnessDown, exec, light -U 10"
      ];

    bindn = [
      ", mouse:272, hy3:focustab, mouse"
    ];
  };
}
