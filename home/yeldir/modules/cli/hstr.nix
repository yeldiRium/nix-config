{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.hstr;
  yeldirsCfg = config.yeldirs;
in {
  options.yeldirs.cli.hstr = {
    enable = lib.mkEnableOption "hstr";
  };

  config = lib.mkIf cfg.enable {
    programs.hstr = {
      enable = true;

      enableZshIntegration = yeldirsCfg.cli.zsh.enable;
    };
  };
}
