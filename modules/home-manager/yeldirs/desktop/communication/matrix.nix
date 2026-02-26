{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.communication.matrix;
in
{
  options = {
    yeldirs.desktop.communication.matrix = {
      enable = lib.mkEnableOption "matrix";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      element-desktop
    ];

    home.persistence = {
      "/persist" = {
        directories = [
          ".config/Element"
        ];
      };
    };
  };
}
