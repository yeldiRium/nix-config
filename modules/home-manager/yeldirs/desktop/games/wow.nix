{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.desktop.games.wow;
in {
  options = {
    yeldirs.desktop.games.wow.enable = lib.mkEnableOption "utilities for world of warcraft";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wowup-cf
    ];

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          "WowUpCf"
        ];
      };
    };
  };
}
