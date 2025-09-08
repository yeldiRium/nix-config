{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.k9s;
  yeldirsCfg = config.yeldirs;
in
{
  options = {
    yeldirs.cli.ops.k9s = {
      enable = lib.mkEnableOption "k9s";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = yeldirsCfg.cli.ops.kubectl.enable;
        message = "kubectl must be enabled for k9s to work";
      }
    ];

    programs.k9s = {
      enable = true;
      package = pkgs.unstable.k9s;
    };
  };
}
