{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    spotifywm
  ];

  xdg.desktopEntries = {
    spotify = {
      name = "Spotify";
      genericName = "Music Player";
      type = "Application";
      exec = "${lib.getExe pkgs.spotifywm} --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto %U";
      icon = "spotify-client";
      categories = ["Audio" "Music" "Player" "AudioVideo"];
      mimeType = ["x-scheme-handler/spotify"];
      terminal = false;
      settings = {
        StartupWMClass = "spotify";
      };
    };
  };
}
