{
  config,
  lib,
  ...
}:
let
  cfg = config.yeldirs.desktop.hyprland;
  desktopCfg = config.yeldirs.desktop;
in
{
  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.sessionVariables = {
      # Makes firefox use wayland directly, improves performance.
      MOZ_ENABLE_WAYLAND = 1;
      # Makes QT applications use wayland.
      QT_QPA_PLATFORM = "wayland";
      # Make electron based apps use wayland.
      NIXOS_OZONE_WL = "1";

      # Idk what this does yet.
      LIBSEAT_BACKEND = "logind";
    };

  };
}
