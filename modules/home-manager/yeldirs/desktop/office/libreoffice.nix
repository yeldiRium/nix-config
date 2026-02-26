{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.office.libreoffice;
in
{
  options = {
    yeldirs.desktop.office.libreoffice.enable = lib.mkEnableOption "libreoffice";
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      libreoffice-fresh
    ];

    home.persistence = {
      "/persist" = {
        directories = [
          ".config/libreoffice"
        ];
      };
    };
  };
}
