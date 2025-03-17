{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.tmux;
in {
  options = {
    yeldirs.cli.essentials.tmux = {
      enable = lib.mkEnableOption "tmux";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      tmux = {
        enable = true;
        clock24 = true;
        keyMode = "vi";
      };
    };
  };
}
