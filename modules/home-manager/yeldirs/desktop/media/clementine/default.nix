{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.desktop.media.clementine;
in {
  options = {
    yeldirs.desktop.media.clementine = {
      enable = lib.mkEnableOption "clementine";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      clementine
    ];

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".config/Clementine"
        ];
      };
    };
  };
}
