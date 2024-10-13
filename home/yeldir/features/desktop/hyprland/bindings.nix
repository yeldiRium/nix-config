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
      workspaces = [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
      ];
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
        map (n: "$mod, ${n}, workspace, ${n}") workspaces
      )
      ++ (
        # Move window to workspace
        map (n: "$mod SHIFT, ${n}, movetoworkspacesilent, ${n}") workspaces
      )
      ++ (
        # Move focus
        (lib.mapAttrsToList (key: direction: "$mod, ${key}, movefocus, ${direction}") directions)
      )
      ++ (
        # Swap windows
        (lib.mapAttrsToList (key: direction: "$mod SHIFT, ${key}, swapwindow, ${direction}") directions)
      )
      ++ (
        # Move workspace to other monitor
        (lib.mapAttrsToList (key: direction: "$mod SHIFT ALT, ${key}, movecurrentworkspacetomonitor, ${direction}") directions)
      )
      ++ [
        # Window management bindings

        "$mod SHIFT, Q, exit" # Exits out of hyprland
        "$mod, Q, killactive" # Closes the focused window
        "$mod, X, killactive" # Closes the focused window

        # adjust layout
        "$mod, Space, togglefloating"
        "$mod, T, togglegroup"
        "$mod, F, fullscreen"
        "$mod, S, togglesplit"
      ]
      ++ [
        # system shortcuts

        # Set shut down, restart and locking features
        # bindsym $mod+0 mode "$mode_system"
        # set $mode_system (l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown
        # mode "$mode_system" {
        #     bindsym l exec --no-startup-id i3exit lock, mode "default"
        #     bindsym s exec --no-startup-id i3exit suspend, mode "default"
        #     bindsym u exec --no-startup-id i3exit switch_user, mode "default"
        #     bindsym e exec --no-startup-id i3exit logout, mode "default"
        #     bindsym h exec --no-startup-id i3exit hibernate, mode "default"
        #     bindsym r exec --no-startup-id i3exit reboot, mode "default"
        #     bindsym Shift+s exec --no-startup-id i3exit shutdown, mode "default"
        #
        #     # exit system mode: "Enter" or "Escape"
        #     bindsym Return mode "default"
        #     bindsym Escape mode "default"
        # }
        "$mod, 0, submap, system"
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
