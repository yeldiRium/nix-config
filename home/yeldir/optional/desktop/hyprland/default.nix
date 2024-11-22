{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.hyprland;
  yeldirsCfg = config.yeldirs;
  rgba = color: alpha: "rgba(${lib.removePrefix "#" color}${alpha})";
in {
  imports = [
    ../common
    ../common/wayland-wm

    ./autostart.nix
    ./bindings.nix
  ];

  options = {
    yeldirs.hyprland.enableAnimations = lib.mkOption {
      type = lib.types.bool;
      description = "Enable hyprland animations";
      default = true;
    };
    yeldirs.hyprland.enableTransparency = lib.mkOption {
      type = lib.types.bool;
      description = "Enable hyprland transparency";
      default = true;
    };
  };

  config = {
    xdg.portal = {
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
      config.hyprland = {
        default = ["hyprland" "gtk"];
      };
    };

    home.packages = with pkgs; [
      grimblast
      hyprpicker
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.unstable.hyprland.override {
        wrapRuntimeDeps = false;
        mesa = pkgs.mesa;
      };
      plugins = [pkgs.unstable.hyprlandPlugins.hy3];
      systemd = {
        enable = true;
        # Same as default, but stop graphical-session too
        extraCommands = lib.mkBefore [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };

      settings = {
        general = {
          layout = "hy3";
          gaps_in = 8;
          gaps_out = 12;
          border_size = 2;
          "col.active_border" = rgba config.colorscheme.colors.primary "aa";
          "col.inactive_border" = rgba config.colorscheme.colors.surface "aa";

          # Tearing seems to freeze steam games in fullscreen with AMD GPUs
          # https://github.com/hyprwm/Hyprland/issues/5097
          allow_tearing = false;
        };
        group = {
          "col.border_active" = rgba config.colorscheme.colors.primary "aa";
          "col.border_inactive" = rgba config.colorscheme.colors.surface "aa";
          groupbar.font_size = 11;
        };
        input = {
          kb_layout = config.yeldirs.system.keyboardLayout;
          kb_variant = config.yeldirs.system.keyboardVariant;
          resolve_binds_by_sym = true;
          touchpad.disable_while_typing = false;

          accel_profile = "flat";
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
        misc = {
          disable_hyprland_logo = true;

          # Unfullscreen when opening something
          new_window_takes_over_fullscreen = 2;
        };
        binds = {
          workspace_back_and_forth = true;
        };

        # Specific window rules for games and applications
        windowrulev2 = let
          steam = "title:^()$,class:^(steam)$";
          steamGame = "class:^(steam_app_[0-9]*)$";
          unfloatApps = [
            steamGame
          ];
          transparentApps =
            if cfg.enableTransparency
            then [] ++ lib.optionals yeldirsCfg.desktop.common.kitty.enable [
                "class:^(kitty)$"
              ]
            else [];
        in [
          "stayfocused, ${steam}"
          "minsize 1 1, ${steam}"
          "immediate, ${steamGame}"
        ] ++ (
          map (app: "tile, ${app}") unfloatApps
        ) ++ (
          map (app: "opacity 0.85, ${app}") transparentApps
        );

        layerrule = [
          "animation fade, hyprpicker"
          "animation fade, selection"

          "animation fade, waybar"
          "blur, waybar"
          "ignorezero, waybar"

          "blur, notifications"
          "ignorezero, notifications"

          "blur, rofi"
          "ignorezero, rofi"
          "dimaround, rofi"

          "noanim, wallpaper"
        ];

        decoration = {
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          fullscreen_opacity = 1.0;
          rounding = 7;
          blur = {
            enabled = cfg.enableTransparency;
            size = 4;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = true;
            popups = true;
          };
          drop_shadow = true;
          shadow_range = 12;
          shadow_offset = "3 3";
          "col.shadow" = "0x44000000";
          "col.shadow_inactive" = "0x66000000";
        };
        plugin = {
          hy3 = {
            tabs = let
              activeAlpha = "ff";
              nonActiveAlpha =
                if cfg.enableTransparency
                then "aa"
                else "ff";
            in {
              "col.active" = rgba config.colorscheme.colors.primary_container activeAlpha;
              "col.urgent" = rgba config.colorscheme.colors.tertiary_container nonActiveAlpha;
              "col.inactive" = rgba config.colorscheme.colors.surface nonActiveAlpha;
              "col.text.active" = rgba config.colorscheme.colors.on_primary_container activeAlpha;
              "col.text.urgent" = rgba config.colorscheme.colors.on_tertiary_container nonActiveAlpha;
              "col.text.inactive" = rgba config.colorscheme.colors.on_surface nonActiveAlpha;
            };
          };
        };
        animations = {
          enabled = cfg.enableAnimations;
          bezier = [
            "easein,0.1, 0, 0.5, 0"
            "easeinback,0.35, 0, 0.95, -0.3"

            "easeout,0.5, 1, 0.9, 1"
            "easeoutback,0.35, 1.35, 0.65, 1"

            "easeinout,0.45, 0, 0.55, 1"
          ];

          animation = [
            "fadeIn,1,3,easeout"
            "fadeLayersIn,1,3,easeoutback"
            "layersIn,1,3,easeoutback,slide"
            "windowsIn,1,3,easeoutback,slide"

            "fadeLayersOut,1,3,easeinback"
            "fadeOut,1,3,easein"
            "layersOut,1,3,easeinback,slide"
            "windowsOut,1,3,easeinback,slide"

            "border,1,3,easeout"
            "fadeDim,1,3,easeinout"
            "fadeShadow,1,3,easeinout"
            "fadeSwitch,1,3,easeinout"
            "windowsMove,1,3,easeoutback"
            "workspaces,1,2.6,easeoutback,slide"
          ];
        };

        exec = [
          "${pkgs.waybar}/bin/waybar -c ${config.home.homeDirectory}/.config/waybar/config"
          "${pkgs.swaybg}/bin/swaybg -i ${config.wallpaper} --mode fill"
          "hyprctl setcursor ${config.gtk.cursorTheme.name} ${toString config.gtk.cursorTheme.size}"
        ];

        monitor = let
          waybarSpace = let
            inherit (config.wayland.windowManager.hyprland.settings.general) gaps_in gaps_out;
            inherit (config.programs.waybar.settings.primary) position height width;
            gap = gaps_out - gaps_in;
          in {
            top =
              if (position == "top")
              then height + gap
              else 0;
            bottom =
              if (position == "bottom")
              then height + gap
              else 0;
            left =
              if (position == "left")
              then width + gap
              else 0;
            right =
              if (position == "right")
              then width + gap
              else 0;
          };
        in
          [
            ",addreserved,${toString waybarSpace.top},${toString waybarSpace.bottom},${toString waybarSpace.left},${toString waybarSpace.right}"
          ]
          ++ (map (
            m: "${m.name},${
              if m.enabled
              then "${toString m.width}x${toString m.height}@${toString m.refreshRate},${m.position},1,transform,${toString m.transform}"
              else "disable"
            }"
          ) (config.monitors));

        workspace = map (m: "name:${m.workspace},monitor:${m.name}") (
          lib.filter (m: m.enabled && m.workspace != null) config.monitors
        );
      };
      # This is order sensitive, so it has to come here.
      extraConfig = let
        swaylock = lib.getExe config.programs.swaylock.package;
        swaylockCmd = "${swaylock} --screenshots --grace 2 --grace-no-mouse";

        exitSubmapAndLock =
          "hyprctl dispatch submap reset"
          + (
            lib.optionalString config.programs.swaylock.enable " && ${swaylockCmd}"
          );
      in ''
        # system shortcuts
        bind = $mod, 0, submap, system
        submap = system
        bind = , escape, submap, reset
        bind = , s, exec, ${exitSubmapAndLock} & systemctl suspend
        bind = , h, exec, ${exitSubmapAndLock} & systemctl hibernate
        bind = , p, exec, systemctl poweroff
        bind = , r, exec, systemctl reboot
        submap = reset

        # resize
        bind = $mod, R, submap, resize
        submap = resize
        bind = , escape, submap, reset
        binde = , I, resizeactive, -10 0
        binde = , E, resizeactive, 10 0
        binde = , L, resizeactive, 0 -10
        binde = , A, resizeactive, 0 10
        binde = , left, resizeactive, -10 0
        binde = , right, resizeactive, 10 0
        binde = , up, resizeactive, 0 -10
        binde = , down, resizeactive, 0 10
        submap = reset

        # Passthrough mode (e.g. for VNC)
        bind = $mod, P, submap, passthrough
        submap = passthrough
        bind = $mod, P, submap, reset
        submap = reset
      '';
    };
  };
}
