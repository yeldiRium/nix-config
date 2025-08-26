{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.desktop.games.openttd;
in {
  options = {
    yeldirs.desktop.games.openttd = {
      enable = lib.mkEnableOption "openttd";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        openttd
        openttd-ttf
      ];

      persistence = {
        "/persist/${config.home.homeDirectory}" = {
          directories = [
            ".local/share/openttd"
          ];
        };
      };
    };
  };
}
