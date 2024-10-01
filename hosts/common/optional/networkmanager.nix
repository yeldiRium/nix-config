{
  networking.networkmanager = {
    enable = true;
  };

  programs.nm-applet.enable = true;

  environment.persistence = {
    "/persist/system" = {
      directories = [
        "/etc/NetworkManager/system-connections"
      ];
    };
  };
}
