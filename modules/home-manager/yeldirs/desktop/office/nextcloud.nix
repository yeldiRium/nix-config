{ config, lib, ... }:
let
  cfg = config.yeldirs.desktop.office.nextcloud;
in
{
  options = {
    yeldirs.desktop.office.nextcloud.enable = lib.mkEnableOption "nextcloud";
  };

  config = lib.mkIf cfg.enable {
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
