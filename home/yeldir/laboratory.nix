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
    ./features/development
    ./features/keyring

    ./features/desktop/chrome.nix
    ./features/desktop/spotify.nix
  ];

  hostName = "laboratory";

  wallpaper = pkgs.wallpapers.nature-calm-valley;

  monitors = [
    {
      name = "LVDS-1";
      width = 1600;
      height = 900;
      workspace = "9";
      position = "1920x800";
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      primary = true;
      position = "0x0";
    }
  ];
}
