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

        "weekstart" = "Monday";

        "urgency.inherit" = "on";
        "urgency.project.coefficient" = "0";
        "urgency.age.coefficient" = "0";
        "news.version" = "2.6.0";

        "report.next.filter" = "status:pending -WAITING";
        "report.next.sort" = "project+/,urgency-";

        "report.next-all.columns" = "id,start.age,entry.age,wait.remaining,depends,priority,project,tags,recur,scheduled.countdown,due.relative,until.remaining,description,urgency";
        "report.next-all.context" = "1";
        "report.next-all.description" = "All tasks, sorted by urgency, categorized by project";
        "report.next-all.filter" = "status:pending or status:waiting";
        "report.next-all.labels" = "ID,Active,Age,Wait,Deps,P,Project,Tag,Recur,S,Due,Until,Description,Urg";
        "report.next-all.sort" = "project+/,urgency-";
      };
    };
  };
}
