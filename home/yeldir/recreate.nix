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
    ./features/desktop/office/calendar.nix
    ./features/desktop/office/contacts.nix
    ./features/desktop/office/email.nix
    ./features/desktop/office/obsidian.nix
    ./features/desktop/video
  ];

  hostName = "recreate";

  wallpaper = pkgs.wallpapers.cyberpunk-tree-landscape;

  monitors = [
    {
      name = "DP-3";
      width = 1920;
      height = 1080;
      position = "1080x200";
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      primary = true;
      position = "0x0";
      transform = 3;
    }
  ];
}
