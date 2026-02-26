# note: This module does not install steam, just the steam-session.
# Steam is installed in the nixos hostConfiguration via programs.steam.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.games.steam;

  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
  steam-session =
    let
      gamescope = lib.concatStringsSep " " [
        (lib.getExe pkgs.gamescope)
        "--output-width ${toString monitor.width}"
        "--output-height ${toString monitor.height}"
        "--framerate-limit ${toString monitor.refreshRate}"
        "--prefer-output ${monitor.name}"
        "--adaptive-sync"
        "--expose-wayland"
        "--hdr-enabled"
        "--steam"
      ];
      steam = lib.concatStringsSep " " [
        "steam"
        "steam://open/bigpicture"
      ];
    in
    pkgs.writeTextDir "share/wayland-sessions/steam-session.desktop" # ini

      ''
        [Desktop Entry]
        Name=Steam Session
        Exec=${gamescope} -- ${steam}
        Type=Application
      '';
in
{
  options = {
    yeldirs.desktop.games.steam = {
      enable = lib.mkEnableOption "steam";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        protonup-ng
        protontricks
        steam-session
      ];

      sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      };

      persistence = {
        "/persist" = {
          directories = [
            ".local/share/Steam"

            ".factorio"
            ".config/Loop_Hero"
            ".config/unity3d/Ludeon Studios/Rimworld by Ludeon Studios"
            ".local/share/aspyr-media" # Borderlands
            ".local/share/Baba_Is_You"
            ".local/share/IntoTheBreach"
          ];
        };
      };
    };
  };
}
