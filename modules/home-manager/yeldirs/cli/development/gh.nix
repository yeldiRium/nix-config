{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.development.gh;
in
{
  options = {
    yeldirs.cli.development.gh = {
      enable = lib.mkEnableOption "gh";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gh = {
        enable = true;
        settings = {
          git_protocol = "ssh";
        };
        extensions = [
          pkgs.gh-copilot
        ];
        gitCredentialHelper.enable = false;
      };

      gh-dash = {
        enable = true;
      };
    };

    home.persistence = {
      "/persist/${config.home.homeDirectory}".files = [ ".config/gh/hosts.yml" ];
    };
  };
}
