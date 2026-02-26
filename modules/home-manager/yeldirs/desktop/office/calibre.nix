{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.office.calibre;
in
{
  options = {
    yeldirs.desktop.office.calibre.enable = lib.mkEnableOption "calibre";
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      calibre
    ];

    home.persistence."/persist" = {
      directories = [
        ".config/calibre"
      ];
    };
  };
}
