{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.communication.telegram;
in
{
  options = {
    yeldirs.desktop.communication.telegram = {
      enable = lib.mkEnableOption "telegram";
    };
  };

  config = lib.mkIf cfg.enable {
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
