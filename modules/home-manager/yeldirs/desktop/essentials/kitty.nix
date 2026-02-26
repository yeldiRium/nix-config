{
  config,
  lib,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.essentials.kitty;
in
{
  options = {
    yeldirs.desktop.essentials.kitty.enable = lib.mkEnableOption "kitty";
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    programs = {
      kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = config.programs.zsh.enable;
      };
    };
  };
}
