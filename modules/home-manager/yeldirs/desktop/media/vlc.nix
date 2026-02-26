{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.media.vlc;
in
{
  options = {
    yeldirs.desktop.media.vlc = {
      enable = lib.mkEnableOption "vlc";
    };
  };

  config = lib.mkIf cfg.enable {
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
