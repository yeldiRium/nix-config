{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.desktop.essentials.kitty;
in {
  options = {
    yeldirs.desktop.essentials.kitty.enable = lib.mkEnableOption "kitty";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = config.programs.zsh.enable;
      };
    };
  };
}
