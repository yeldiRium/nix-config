{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.watching;
in
{
  options = {
    yeldirs.cli.ops.watching = {
      enable = lib.mkEnableOption "tools for watching things";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ttyplot
      (y.shellScript ./watching-scripts/watchcmd)
    ];
  };
}
