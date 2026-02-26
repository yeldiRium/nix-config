{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.communication.telegram;
in
{
  options = {
    yeldirs.desktop.communication.telegram = {
      enable = lib.mkEnableOption "telegram";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      telegram-desktop
    ];

    home.persistence."/persist" = {
      directories = [
        ".local/share/TelegramDesktop"
      ];
    };
  };
}
