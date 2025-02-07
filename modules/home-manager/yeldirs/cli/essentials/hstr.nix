{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.hstr;
  yeldirsCfg = config.yeldirs;
in {
  options.yeldirs.cli.essentials.hstr = {
    enable = lib.mkEnableOption "hstr";
  };

  config = lib.mkIf cfg.enable {
    programs.hstr = {
      enable = true;

      enableZshIntegration = yeldirsCfg.cli.essentials.zsh.enable;
    };
  };
}
