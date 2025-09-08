{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.fs-tools;
in
{
  options = {
    yeldirs.cli.ops.fs-tools = {
      enable = lib.mkEnableOption "fs-tools";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      exfat
    ];
  };
}
