{ config, lib, ... }:
let
  cfg = config.yeldirs.docker;
in
{
  options = {
    yeldirs.docker = {
      enable = lib.mkEnableOption "docker";

      storageRoot = lib.mkOption {
        type = lib.types.str;
        default = "";
      };

      enablePersistence = lib.mkEnableOption "persist docker storage root";
    };
  };
  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      logDriver = "json-file";

      # I use cadvisor to scrape metrics. cadvisor is incompatible with overlayfs,
      # which is the default.
      # https://github.com/google/cadvisor/issues/3772
      storageDriver = "overlay2";

      daemon.settings = {
        data-root = lib.mkIf (cfg.storageRoot != "") cfg.storageRoot;
      };
    };

    environment.persistence = lib.mkIf cfg.enablePersistence {
      "/persist/system" = {
        directories = [
          (if (cfg.storageRoot != "") then cfg.storageRoot else "/var/lib/docker")
        ];
      };
    };
  };
}
