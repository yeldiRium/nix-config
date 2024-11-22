{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.lazydocker;
in {
  options = {
    yeldirs.cli.lazydocker = {
      enable = lib.mkEnableOption "lazydocker";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lazydocker
    ];
  };
}
