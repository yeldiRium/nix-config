{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../common/wayland-wm
  ];

  xdg.portal = {
    config.hyprland = {
      default = ["wlr" "gtk"];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };

    plugins = [
      pkgs.hyprlandPlugins.hyprbars
    ];

    settings = {
      input = {
        kb_layout = "de";
        kb_variant = "neo";
        resolve_binds_by_sym = true;
      };
      device =
        map (keyboard: {
          name = "${keyboard}";
          kb_layout = "de";
          kb_variant = "";
        }) [
          "zsa-technology-labs-inc-ergodox-ez"
          "zsa-technology-labs-inc-ergodox-ez-keyboard"
          "zsa-technology-labs-inc-ergodox-ez-system-control"
          "zsa-technology-labs-inc-ergodox-ez-consumer-control"
        ];

      exec = [
        "${pkgs.waybar}/bin/waybar"
        #"hyperctl setcursor ${config.gtk.cursorTheme.name} ${toString config.gtk.cursorTheme.size}"
      ];

      "$mod" = "SUPER";
      "$terminal" = "kitty";

      # TODO: add swaybg or similar for wallpaper

      # TODO: configure monitors

      # TODO: configure hyprland appearance

      # TODO: add bindings for
      # - pactl (volume)
      # - playerctl (track)
      # - screenshots
      # - brightness (lightd)
      # - lock (swaylock or similar)
      bind =
        [
          "$mod SHIFT, Q, exit" # Exits out of hyprland
          "$mod, Q, killactive" # Closes the focused window
          "$mod, X, killactive" # Closes the focused window
          "$mod, Return, exec, $terminal" # Launches a terminal
        ]
        ++ (
          # Notification manager
          let
            makoctl = lib.getExe' config.services.mako.package "makoctl";
          in
            lib.optionals config.services.mako.enable [
              "SUPER, w, exec, ${makoctl} dismiss"
              "SUPERSHIFT, w, exec, ${makoctl} restore"
            ]
        )
        ++ (
          # Launch programs with wofi
          let
            wofi = lib.getExe config.programs.wofi.package;
          in
            lib.optionals config.programs.wofi.enable [
              "$mod, D, exec, ${wofi} --show run"
              "$mod SHIFT, D, exec, ${wofi} --show drun -x 10 -y 10 --width 25% --height 80%"
            ]
        )
        ++ (
          # Lock screen with swaylock
          let
            swaylock = lib.getExe config.programs.swaylock.package;
          in
            lib.optionals config.programs.swaylock.enable [
              "$mod, L, exec, ${swaylock} --screenshots --grace 2 --grace-no-mouse"
              "$mod, XF86ScreenSaver, exec, ${swaylock} --screenshots --grace 2 --grace-no-mouse"
            ]
        )
        ++ [
          # navigate around windows
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
        ]
        ++ [
          # adjust layout
          "$mod, Space, togglefloating"
          "$mod, G, togglegroup"
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
        );
    };
  };
}
