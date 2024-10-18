{pkgs, ...}: let
  gdlauncher = pkgs.appimageTools.wrapType2 {
    name = "gdlauncher";
    src = pkgs.fetchurl {
      url = "https://cdn-raw.gdl.gg/launcher/GDLauncher__2.0.20__linux__x64.AppImage";
      hash = "sha256-tI9RU8qO3MHbImOGw2Wl1dksNbhqrYFyGemqms8aAio=";
    };
  };
in {
  home.packages = [
    gdlauncher
  ];
}
