{
  config,
  lib,
  pkgs,
  ...
}: let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
  steam-session = let
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
in {
  home.packages = with pkgs; [
    protontricks
    steam-session
  ];

  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
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
}
