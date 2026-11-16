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

      pruneImages = lib.mkEnableOption "prunes images regularly";
    };
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
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
      }
      (lib.mkIf cfg.enablePersistence {
        environment.persistence = {
          "/persist/system" = {
            directories = [
              (if (cfg.storageRoot != "") then cfg.storageRoot else "/var/lib/docker")
            ];
          };
        };
      })
      (lib.mkIf cfg.pruneImages {

        systemd.services.docker-prune-images = {
          description = "Prune Docker images";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${config.virtualisation.docker.package}/bin/docker image prune --all --force";
          };
        };

        systemd.timers.docker-prune-images = {
          description = "Prune docker images daily at 2:00 AM UTC";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "*-*-* 02:00:00 UTC";
            Persistent = true;
          };
        };
      })
    ]
  );
}
