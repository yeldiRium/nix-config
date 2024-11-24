{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.thefuck;
  yeldirsCfg = config.yeldirs;
in {
  options = {
    yeldirs.cli.essentials.thefuck = {
      enable = lib.mkEnableOption "thefuck";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.thefuck = {
      enable = true;
      enableZshIntegration = yeldirsCfg.cli.essentials.zsh.enable;
    };
  };
}
