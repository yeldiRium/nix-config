{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.ssh;
in {
  options = {
    yeldirs.cli.essentials.ssh = {
      enable = lib.mkEnableOption "ssh";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      ssh = {
        enable = true;
        matchBlocks = {
          "github.com" = {
            user = "yeldir";
            identityFile = "~/.ssh/hleutloff";
          };
          "git.staubwolke.org" = {
            user = "yeldir";
            identityFile = "~/.ssh/hleutloff";
            port = 30022;
          };
          "datengrab" = {
            user = "yeldir";
            identityFile = "~/.ssh/hleutloff";
          };
          "heck" = {
            hostname = "yeldirium.de";
            user = "yeldir";
            identityFile = "~/.ssh/hleutloff";
          };
        };
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