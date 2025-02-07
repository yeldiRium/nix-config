{
  lib,
  config,
  ...
}: let
  cfg = config.yeldirs.cli.development.gh;
in {
  options = {
    yeldirs.cli.development.gh = {
      enable = lib.mkEnableOption "gh";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
    home.persistence = {
      "/persist/${config.home.homeDirectory}".files = [".config/gh/hosts.yml"];
    };
  };
}
