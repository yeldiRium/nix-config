{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.media.clementine;
in
{
  options = {
    yeldirs.desktop.media.clementine = {
      enable = lib.mkEnableOption "clementine";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      clementine
    ];

    home.persistence = {
      "/persist" = {
        directories = [
          ".config/Clementine"
        ];
      };
    };
  };
}
