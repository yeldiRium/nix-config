{
  config,
  lib,
  ...
}:
let
  essentials = config.yeldirs.cli.essentials;
  cfg = config.yeldirs.cli.essentials.ssh;
in
{
  options = {
    yeldirs.cli.essentials.ssh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = essentials.enable;
      };
      excludePrivate = lib.mkEnableOption "exclude private configs";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      ssh = {
        enable = true;
        matchBlocks = {
          "github.com" = {
            user = "git";
            identityFile = "~/.ssh/hleutloff";
          };
          "git.staubwolke.org" = {
            user = "git";
            identityFile = "~/.ssh/hleutloff";
            port = 30022;
          };
        }
        // (
          if config.yeldirs.workerSupport then
            lib.y.workers.eachToAttrs (w: {
              name = "worker-${w.shortname} ${w.ipv6}";
              value = {
                hostname = w.hostName;
                user = "worker";
                identityFile = "~/.ssh/worker";
                port = 58008;
              };
            })
          else
            { }
        )
        // (
          if cfg.excludePrivate then
            { }
          else
            {
              "datengrab" = {
                user = "yeldir";
                identityFile = "~/.ssh/hleutloff";
              };
              "heck" = {
                hostname = "yeldirium.de";
                user = "yeldir";
                identityFile = "~/.ssh/hleutloff";
              };
              "backup" = {
                hostname = "192.168.178.41";
                user = "yeldir";
                identityFile = "~/.ssh/hleutloff";
              };
            }
        );
      };
    };

    home = {
      persistence = {
        "/persist/${config.home.homeDirectory}" = {
          directories = [
            ".ssh"
          ];
        };
      };
    };
  };
}
