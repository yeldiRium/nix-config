{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.games.gog;
in
{
  options = {
    yeldirs.desktop.games.gog = {
      enable = lib.mkEnableOption "gog";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      minigalaxy
    ];

    home.persistence = {
      "/persist" = {
        directories = [
          # Unfortunately, minigalaxy downloads games to cache before moving them to ~/Games.
          # To avoid filling up the tempfs, we have to persist this.
          ".cache/minigalaxy/download"

          ".config/minigalaxy"
          "Games"

          # For manually installed games
          "GOG Games"
        ];
      };
    };
  };
}
