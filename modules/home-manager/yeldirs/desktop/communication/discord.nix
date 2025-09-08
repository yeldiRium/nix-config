{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.communication.discord;
in
{
  options = {
    yeldirs.desktop.communication.discord = {
      enable = lib.mkEnableOption "discord";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vesktop
    ];

    home.persistence."/persist/${config.home.homeDirectory}" = {
      directories = [
        ".config/vesktop"
      ];
    };
  };
}
