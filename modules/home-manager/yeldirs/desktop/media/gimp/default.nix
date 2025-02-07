{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.desktop.media.gimp;
in {
  options = {
    yeldirs.desktop.media.gimp = {
      enable = lib.mkEnableOption "gimp";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp
    ];
  };
}
