{ config, ... }:
{
  services.nextcloud-client = {
    enable = true;
  };

  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".config/Nextcloud"
    ];
  };
}
