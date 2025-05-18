{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.mounts.datengrab;
in {
  options = {
    yeldirs.mounts.datengrab.enable = lib.mkEnableOption "Enable mount datengrab";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sshfs
    ];

    programs.ssh = {
      extraConfig = ''
        Host datengrab
          User yeldir
          IdentityFile ${config.users.users.yeldir.home}/.ssh/hleutloff
      '';
      knownHosts = {
        datengrab = {
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHHAQQrrZtf+iL/QySaxfg29Y2hZx/6ySy4SbMOxdO9";
        };
        "datengrab/ecdsa" = {
          hostNames = ["datengrab"];
          publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPs4cbixkaqvjU5qJBVh2poCYDdOF1Q0pat0QL1vfBHXwG6AMCYJiqnshkKdBLAM9TbKOdDA/tsK70qFgtHVavM=";
        };
      };
    };

    systemd.mounts = [
      {
        type = "fuse.sshfs";
        mountConfig = {
          Options = "allow_other";
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
