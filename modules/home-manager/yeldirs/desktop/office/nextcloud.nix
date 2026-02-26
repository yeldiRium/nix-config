{ config, lib, ... }:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.office.nextcloud;
in
{
  options = {
    yeldirs.desktop.office.nextcloud.enable = lib.mkEnableOption "nextcloud";
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    services.nextcloud-client = {
      enable = true;
    };

    home.persistence."/persist" = {
      directories = [
        ".config/Nextcloud"
      ];
    };
  };
}
