{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.qmk;
in {
  options = {
    yeldirs.cli.qmk = {
      enable = lib.mkEnableOption "qmk";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      qmk
      qmk-udev-rules
    ];

    xdg.configFile = {
      "qmk/qmk.ini".source = pkgs.writeText "qmk.ini" (builtins.readFile ./qmk.ini);
    };
  };
}
