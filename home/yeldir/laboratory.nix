{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./global

    ./optional/desktop/hyprland
    ./optional/desktop/development
    ./optional/keyring

    ./optional/desktop/chrome.nix
    ./optional/desktop/spotify.nix
    ./optional/desktop/office/calendar.nix
    ./optional/desktop/office/contacts.nix
    ./optional/desktop/office/email.nix
    ./optional/desktop/office/obsidian.nix
    ./optional/desktop/video
  ];

  hostName = "laboratory";

  wallpaper = pkgs.wallpapers.cyberpunk-tree-landscape;

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
