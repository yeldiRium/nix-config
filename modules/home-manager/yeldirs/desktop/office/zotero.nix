{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.office.zotero;
in
{
  options = {
    yeldirs.desktop.office.zotero.enable = lib.mkEnableOption "zotero";
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      zotero
    ];

    home.persistence = {
      "/persist" = {
        directories = [
          ".zotero"
          "Zotero"
        ];
      };
    };
  };
}
