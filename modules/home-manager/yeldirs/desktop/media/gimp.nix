{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.media.gimp;
in
{
  options = {
    yeldirs.desktop.media.gimp = {
      enable = lib.mkEnableOption "gimp";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      gimp
    ];
  };
}
