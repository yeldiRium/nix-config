{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.media.vlc;
in
{
  options = {
    yeldirs.desktop.media.vlc = {
      enable = lib.mkEnableOption "vlc";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      vlc
    ];

    home.persistence = {
      "/persist" = {
        directories = [
          ".config/vlc"
        ];
      };
    };
  };
}
