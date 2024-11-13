{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.desktop.office.zotero;
in {
  options = {
    yeldirs.desktop.office.zotero.enable = lib.mkEnableOption "zotero";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zotero
    ];

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".zotero"
          "Zotero"
        ];
      };
    };
  };
}
