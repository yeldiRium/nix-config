{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  environment.persistence = {
    "/persist/system" = {
      directories = [
        "/var/lib/docker"
      ];
    };
  };
}
