{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./global

    ./features/desktop/hyprland
    ./features/desktop/chrome.nix
    ./features/development
    ./features/pass
  ];

  hostName = "laboratory";

  wallpaper = pkgs.wallpapers.nature-calm-valley;

  monitors = [
    {
      name = "LVDS-1";
      width = 1600;
      height = 900;
      workspace = "2";
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      workspace = "1";
      primary = true;
    }
  ];
}
