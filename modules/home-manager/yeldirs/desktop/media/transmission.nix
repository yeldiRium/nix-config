{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.media.transmission;
in
{
  options = {
    yeldirs.desktop.media.transmission = {
      enable = lib.mkEnableOption "transmission";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home = {
      packages = with pkgs; [
        transmission-remote-gtk
      ];
      persistence."/persist" = {
        directories = [
          ".config/transmission-remote-gtk"
        ];
      };
    };
  };
}
