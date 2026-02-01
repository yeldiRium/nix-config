{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    logDriver = "json-file";
  };

  environment.persistence = {
    "/persist/system" = {
      directories = [
        "/var/lib/docker"
      ];
    };
  };
}
