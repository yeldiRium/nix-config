{
  config,
  lib,
  ...
}: let
  essentials = config.yeldirs.cli.essentials;
  cfg = config.yeldirs.cli.essentials.ssh;
in {
  options = {
    yeldirs.cli.essentials.ssh = {
      excludePrivate = lib.mkEnableOption "exclude private configs";
    };
  };

  config = lib.mkIf essentials.enable {
    programs = {
      ssh = {
        enable = true;
        matchBlocks =
          {
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
            if cfg.excludePrivate
            then {}
            else {
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
