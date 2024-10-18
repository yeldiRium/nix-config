{
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings.exec-once = [
    "[workspace 2 silent; monitor DP-3] ${lib.getExe pkgs.google-chrome}"
    "[workspace 3 silent; monitor DP-3] ${lib.getExe pkgs.lutris}"
    "[workspace 5 silent; monitor DP-3] ${lib.getExe pkgs.obsidian}"
    "[workspace 7 silent; monitor DP-3] ${lib.getExe pkgs.thunderbird}"
  ];
}
