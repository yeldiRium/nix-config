{
  services.nextcloud-client = {
    enable = true;
  };

  home.persistence."/persist" = {
    directories = [
      ".config/Nextcloud"
    ];
  };
}
