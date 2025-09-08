{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.lazydocker;
in
{
  options = {
    yeldirs.cli.ops.lazydocker = {
      enable = lib.mkEnableOption "lazydocker";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lazydocker
    ];
  };
}
