{config, lib, pkgs, ...}: let
  cfg = config.yeldirs.mounts.datengrab;
in {
  options = {
    yeldirs.mounts.datengrab.enable = lib.mkEnableOption "Enable mount datengrab";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sshfs
    ];

    programs.ssh.extraConfig = ''
      Host datengrab
        User yeldir
        IdentityFile ${config.users.users.yeldir.home}/.ssh/hleutloff
      '';

    systemd.mounts = [
      {
        type = "fuse.sshfs";
        mountConfig = {
          Options = "allow_other,default_permissions";
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
