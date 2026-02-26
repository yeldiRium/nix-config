{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.office.libreoffice;
in
{
  options = {
    yeldirs.desktop.office.libreoffice.enable = lib.mkEnableOption "libreoffice";
  };

  config = lib.mkIf cfg.enable {
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
