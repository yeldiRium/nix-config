{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.desktop.common.kitty;
  yeldirsCfg = config.yeldirs;
in {
  options = {
    yeldirs.desktop.common.kitty.enable = lib.mkEnableOption "kitty";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = yeldirsCfg.cli.zsh.enable;
      };
    };
  };
}
