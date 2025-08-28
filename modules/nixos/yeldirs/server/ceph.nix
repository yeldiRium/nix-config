{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.server.ceph;
in {
  options = {
    yeldirs.server.ceph = {
      enable = lib.mkEnableOption "ceph";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ceph
    ];

    services.ceph = {
      enable = true;
      client.enable = true;

      global = {
        fsid = "ce4d7787-0414-4dcf-829a-959a278f5fd9";
        monHost =
          lib.mapAttrsToList (_: w: "nixos-${w.shortname}") lib.y.workers.workers
          |> lib.strings.concatStringsSep " ";
      };
      osd = {
        enable = true;
        daemons = ["0"];
      };
      mon = {
        enable = true;
        daemons = ["0"];
      };
      mgr = {
        enable = true;
        daemons = ["0"];
      };
    };
  };
}
