{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.bat;
in {
  options = {
    yeldirs.cli.essentials.bat = {
      enable = lib.mkEnableOption "bat";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config.theme = "base16";
    };
  };
}
