{pkgs, ...}: {
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
}
