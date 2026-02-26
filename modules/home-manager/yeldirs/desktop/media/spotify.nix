{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.media.spotify;
in
{
  options = {
    yeldirs.desktop.media.spotify = {
      enable = lib.mkEnableOption "spotify";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      spotifywm
    ];

    home.persistence."/persist" = {
      directories = [
        ".config/spotify"
      ];
    };

    xdg.desktopEntries = {
      spotify = {
        name = "Spotify";
        genericName = "Music Player";
        type = "Application";
        exec = "${lib.getExe pkgs.spotifywm} --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto %U";
        icon = "spotify-client";
        categories = [
          "Audio"
          "Music"
          "Player"
          "AudioVideo"
        ];
        mimeType = [ "x-scheme-handler/spotify" ];
        terminal = false;
        settings = {
          StartupWMClass = "spotify";
        };
      };
    };
  };
}
