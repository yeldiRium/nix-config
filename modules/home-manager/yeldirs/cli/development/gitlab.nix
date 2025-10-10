{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.development.gitlab;
in
{
  options = {
    yeldirs.cli.development.gitlab = {
      enable = lib.mkEnableOption "gitlab";
      enableSopsToken = lib.mkOption {
        type = lib.types.bool;
        description = "take gitlab access token from sops";
        default = cfg.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.enableSopsToken || config.yeldirs.system.sops.enable;
        message = "To use the gitlab access token from sops, sops has to be enabled";
      }
    ];
    home = {
      packages = with pkgs; [
        glab
      ];
    };

    sops.secrets.gitlabAccessToken = lib.mkIf cfg.enableSopsToken { };
    programs.zsh = {
      envExtra = lib.mkIf cfg.enableSopsToken "export GITLAB_TOKEN=$(cat ${config.sops.secrets.gitlabAccessToken.path})";
    };

    home.persistence = {
      "/persist/${config.home.homeDirectory}".directories = [ ".config/glab-cli" ];
    };
  };
}
