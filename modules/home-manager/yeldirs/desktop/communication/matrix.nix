{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.desktop.communication.matrix;
in {
  options = {
    yeldirs.desktop.communication.matrix = {
      enable = lib.mkEnableOption "matrix";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      element-desktop
    ];

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".config/Element"
        ];
      };
    };
  };
}
