{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.desktop.games.nds;
in {
  options = {
    yeldirs.desktop.games.nds.enable = lib.mkEnableOption "nds";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      desmume
    ];

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".config/desmume"
        ];
      };
    };
  };
}
