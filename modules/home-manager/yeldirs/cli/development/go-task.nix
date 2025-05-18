{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.development.go-task;
in {
  options = {
    yeldirs.cli.development.go-task = {
      enable = lib.mkEnableOption "go-task";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      go-task
    ];
  };
}
