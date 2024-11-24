{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.desktop.essentials.kitty;
  yeldirsCfg = config.yeldirs;
in {
  options = {
    yeldirs.desktop.essentials.kitty.enable = lib.mkEnableOption "kitty";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = yeldirsCfg.cli.essentials.zsh.enable;
      };
    };
  };
}
