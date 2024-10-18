{
  pkgs,
  lib,
  config,
  ...
}: let
  # Steam usage guide with lutris:
  #
  # Lutris somehow can't start steam reliably. Games are
  # also installed, managed and launched via steam, so it
  # has to be installed and configured.
  # In lutris, steam games can be added to the library.
  # This does not install them, it just registers them with
  # lutris.
  #
  # To install and start a game, steam must be started
  # manuall, so that it fully open and logs in. Then
  # launching a game that was registered with lutris will
  # launch into the running steam instance and start the
  # game/ask for installation.
  #
  # Games can only be registered with lutris after logging
  # into steam once and setting the games on your user
  # profile to public.
  steam-with-pkgs = pkgs.steam.override {
    extraPkgs = pkgs:
      with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        gamescope
      ];
  };
in {
  home.packages = [
    steam-with-pkgs
  ];

  # TODO: disable steam desktop entry
  #xdg.desktopEntries = {
  #  steam = {
  #    noDisplay = true;
  #  };
  #};

  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
      allowOther = true;
      directories = [
        ".local/share/Steam"

        ".factorio"
        ".local/share/aspyr-media" # Borderlands
        ".local/share/Baba_Is_You"
        ".local/share/IntoTheBreach"
      ];
    };
  };
}
