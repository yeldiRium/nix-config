{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.docker;
in
{
  options = {
    yeldirs.cli.ops.docker = {
      enable = lib.mkEnableOption "docker";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lazydocker
      y.docker-volume-backup
      y.docker-volume-inspect
    ];
  };
}
