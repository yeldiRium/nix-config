{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.mounts.datengrab;
in
{
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
          IdentityFile ${config.users.users.yeldir.home}/.ssh/hleutloff02
      '';
      knownHosts = {
        datengrab = {
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG2NATryhaBhnV/a8gVDpqyxwcfIh6g4aDoJxYNa6kqU";
        };
      };
    };

    systemd.mounts = [
      {
        type = "fuse.sshfs";
        mountConfig = {
          Options = "allow_other";
        };
        what = "datengrab:/storage";
        where = "/mnt/datengrab";
      }
    ];

    systemd.automounts = [
      {
        wantedBy = [ "multi-user.target" ];
        automountConfig = {
          TimeoutIdleSec = "600";
        };
        where = "/mnt/datengrab";
      }
    ];
  };
}
