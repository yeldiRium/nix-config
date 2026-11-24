{
  config,
  lib,
  ...
}:
let
  inherit (config.yeldirs.cli) essentials;
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
        enableDefaultConfig = false;
        settings = {
          "github.com" = {
            user = "git";
            identityFile = "~/.ssh/hleutloff02";
          };
          "git.staubwolke.org" = {
            user = "git";
            identityFile = "~/.ssh/hleutloff02";
            port = 30022;
          };
        }
        // (
          if cfg.excludePrivate then
            { }
          else
            {
              "datengrab" = {
                user = "yeldir";
                identityFile = "~/.ssh/hleutloff02";
              };
              "heck" = {
                hostname = "yeldirium.de";
                user = "yeldir";
                identityFile = "~/.ssh/hleutloff02";
              };
              "nuc" = {
                hostname = "nuc";
                user = "yeldir";
                identityFile = "~/.ssh/hleutloff02";
              };
            }
        );
      };
    };

    home = {
      persistence = {
        "/persist" = {
          directories = [
            ".ssh"
          ];
        };
      };
    };
  };
}
