{config, lib, ...}: let
  cfg = config.yeldirs.mounts.datengrab;
in {
  options = {
    yeldirs.mounts.datengrab.enable = lib.mkEnableOption "Enable mount datengrab";
  };
  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems = ["nfs"];
    services.rpcbind.enable = true;

    systemd.mounts = [
      {
        type = "nfs";
        mountConfig = {
          Options = "noatime";
        };
        what = "datengrab:/mnt/raid";
        where = "/mnt/datengrab";
      }
    ];

    systemd.automounts = [
      {
        wantedBy = ["multi-user.target"];
        automountConfig = {
          TimeoutIdleSec = "600";
        };
        where = "/mnt/datengrab";
      }
    ];
  };
}
