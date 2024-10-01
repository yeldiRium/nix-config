{
  networking.networkmanager = {
    enable = true;
  };

  environment.persistence = {
    "/persist/system" = {
      directories = [
        "/etc/NetworkManager/system-connections"
      ];
    };
  };
}
