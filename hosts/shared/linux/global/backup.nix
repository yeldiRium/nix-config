{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.common.global.backup;

  hostName = config.networking.hostName;
in {
  options = {
    yeldirs.common.global.backup = {
      enable = lib.mkEnableOption "backups";
      sshKeyPath = lib.mkOption {
        type = lib.types.path;
        example = "/home/yeldir/.ssh/hleutloff";
      };
      patterns = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = ''
          - "R /persist"
          - "- home/yeldir/.local/share/Steam"
        '';
        description = "A list of borg patterns. See borg help patterns for more information.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.sshKeyPath != null;
        message = "The ssh key to access the backup server must be configured for borg backups to work.";
      }
      {
        assertion = cfg.patterns != "";
        message = "At least one pattern must be configured for borg backups to work.";
      }
    ];

    environment.shellAliases = {
      "backup-create" = "sudo borgmatic create --verbosity 1 --list --stats";
    };

    services.borgmatic = {
      enable = true;
    };

    environment.etc = {
      "borgmatic.d/${hostName}.yaml" = {
        text = ''
          repositories:
          - label: ${hostName}
            path: ssh://yeldir@backup/mnt/raid/borg/${hostName}
          patterns:
          ${cfg.patterns}
        '';
      };
    };

    environment.sessionVariables = {
      BORG_PASSCOMMAND = "cat /run/secrets/borg-encryption-${hostName}";
    };

    programs.ssh.extraConfig = ''
      Host backup
        HostName 192.168.178.41
        User yeldir
        IdentityFile ${cfg.sshKeyPath}
    '';

    sops.secrets.borg-encryption-recreate = {
      sopsFile = ../../secrets.yaml;
    };
  };
}
