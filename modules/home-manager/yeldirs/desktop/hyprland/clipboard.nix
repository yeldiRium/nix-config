{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.hyprland;
  desktopCfg = config.yeldirs.desktop;
in
{
  # Clipboard History is in ./rofi.nix
  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home = {
      packages = with pkgs; [
        wl-clipboard
      ];

      shellAliases = {
        clipc = "wl-copy";
      };
    };
  };
}
