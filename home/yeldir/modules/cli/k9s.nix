{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.k9s;
  yeldirsCfg = config.yeldirs;
in {
  options = {
    yeldirs.cli.k9s = {
      enable = lib.mkEnableOption "k9s";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = yeldirsCfg.cli.kubectl.enable;
        message = "kubectl must be enabled for k9s to work";
      }
    ];

    programs.k9s = {
      enable = true;
    };
  };
}
