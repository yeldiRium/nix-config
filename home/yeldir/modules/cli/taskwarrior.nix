{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.taskwarrior;
in {
  options = {
    yeldirs.cli.taskwarrior.enable = lib.mkEnableOption "taskwarrior";
  };

  config = lib.mkIf cfg.enable {
    programs.taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      dataLocation = "${config.home.homeDirectory}/querbeet/nextcloud/taskwarrior";
      colorTheme = "dark-gray-blue-256";
      config = {
        "_forcecolor" = "off";
        
        "urgency.inherit" = "on";
        "urgency.project.coefficient" = "0";
        "urgency.age.coefficient" = "0";
        "news.version" = "2.6.0";
      };
    };
  };
}
