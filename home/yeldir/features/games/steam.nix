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
in {
  home.shellAliases = {
    # Steam doesn't always shutdown properly. This catches
    # all steam processes but avoids impermanence mounts.
    killsteam = "ps aux | ag steam | ag --invert-match bindfs | sed --regexp-extended \"s/^yeldir\s+([0-9]+).*/\1/\" | xargs kill";
  };

  # Steam installation is done host wide, since nixos has
  # more scripts for it.
  # This file only contains persistence for game saves.
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
