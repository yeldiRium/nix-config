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

    ./features/desktop/communication
    ./features/desktop/chrome.nix
    ./features/desktop/spotify.nix
    ./features/desktop/office/calendar.nix
    ./features/desktop/office/contacts.nix
    ./features/desktop/office/email.nix
    ./features/desktop/office/hledger.nix
    ./features/desktop/office/obsidian.nix
    ./features/desktop/video
    ./features/games
  ];

  hostName = "recreate";

  wallpaper = pkgs.wallpapers.cyberpunk-tree-landscape;

  monitors = [
    {
      name = "DP-3";
      width = 1920;
      height = 1080;
      position = "1080x200";
      primary = true;
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      position = "0x0";
      transform = 3;
      workspace = "1";
    }
  ];
  autostart = [
    {
      command = "${lib.getExe pkgs.telegram-desktop}";
      workspace = "1";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.vesktop}";
      workspace = "1";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.google-chrome}";
      workspace = "2";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.lutris}";
      workspace = "3";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.steam}";
      workspace = "3";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.obsidian}";
      workspace = "5";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.spotify}";
      workspace = "6";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.thunderbird}";
      workspace = "7";
      monitor = "DP-3";
    }
  ];
}
