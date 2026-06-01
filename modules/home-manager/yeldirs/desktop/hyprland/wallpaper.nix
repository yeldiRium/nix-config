{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.hyprland;
  desktopCfg = config.yeldirs.desktop;

  hyprpaper = lib.getExe pkgs.hyprpaper;
in
{
  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    wayland.windowManager.hyprland.extraConfig = # lua
      ''
        hl.on("hyprland.start", function ()
          hl.exec_cmd("${hyprpaper}")
        end)
      '';

    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        wallpaper = {
          monitor = ""; # All monitors
          path = "${config.wallpaper}";
        };
      };
    };
  };
}
