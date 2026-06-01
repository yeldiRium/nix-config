{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.hyprland;
  desktopCfg = config.yeldirs.desktop;
  inherit (config.colorscheme) colors;

  swaylock = lib.getExe config.programs.swaylock.package;
  swaylockCmd = "${swaylock} --screenshots --grace 2 --grace-no-mouse";
  exitSubmapAndLock =
    "hyprctl dispatch submap reset"
    + (lib.optionalString config.programs.swaylock.enable " && ${swaylockCmd}");
in
{
  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      hyprshutdown
    ];

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        effect-blur = "20x3";
        fade-in = 0.1;

        font = config.fontProfiles.regular.name;
        font-size = config.fontProfiles.regular.size + 3;

        line-uses-inside = true;
        disable-caps-lock-text = true;
        indicator-caps-lock = true;
        indicator-radius = 40;
        indicator-idle-visible = true;
        indicator-y-position = 1000;

        ring-color = "${colors.surface_bright}";
        inside-wrong-color = "${colors.on_error}";
        ring-wrong-color = "${colors.error}";
        key-hl-color = "${colors.tertiary}";
        bs-hl-color = "${colors.on_tertiary}";
        ring-ver-color = "${colors.secondary}";
        inside-ver-color = "${colors.on_secondary}";
        inside-color = "${colors.surface}";
        text-color = "${colors.on_surface}";
        text-clear-color = "${colors.on_surface_variant}";
        text-ver-color = "${colors.on_secondary}";
        text-wrong-color = "${colors.on_surface_variant}";
        text-caps-lock-color = "${colors.on_surface_variant}";
        inside-clear-color = "${colors.surface}";
        ring-clear-color = "${colors.primary}";
        inside-caps-lock-color = "${colors.on_tertiary}";
        ring-caps-lock-color = "${colors.surface}";
        separator-color = "${colors.surface}";
      };
    };

    wayland.windowManager.hyprland.extraConfig = # lua
      ''
        -- system shortcuts
        hl.bind("SUPER + 0", hl.dsp.submap("system"))
        hl.define_submap("system", function()
          hl.bind("escape", hl.dsp.submap("reset"))

          hl.bind("S", hl.dsp.exec_cmd("${exitSubmapAndLock} & systemctl suspend"))
          hl.bind("H", hl.dsp.exec_cmd("${exitSubmapAndLock} & systemctl hibernate"))
          hl.bind("P", hl.dsp.exec_cmd("systemctl poweroff"))
          hl.bind("R", hl.dsp.exec_cmd("systemctl reboot"))
          hl.bind("Q", hl.dsp.exec_cmd("hyprshutdown"))
        end)

        -- lock screen
        hl.bind("SUPER + G", hl.dsp.exec_cmd("${swaylockCmd}"))
        hl.bind("XF86ScreenSaver", hl.dsp.exec_cmd("${swaylockCmd}"))

        -- passthrough mode, disables all bindings while submap is active
        hl.bind("SUPER + P", hl.dsp.submap("passthrough"))
        hl.define_submap("passthrough", function()
            hl.bind("escape", hl.dsp.submap("reset"))
        end)

        -- brightness controls
        hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("light -A 10"))
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("light -U 10"))
      '';
  };
}
