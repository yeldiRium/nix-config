{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.communication.discord;
in
{
  options = {
    yeldirs.desktop.communication.discord = {
      enable = lib.mkEnableOption "discord";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      vesktop
    ];

    home.persistence."/persist" = {
      directories = [
        ".config/vesktop"
      ];
    };
  };
}
