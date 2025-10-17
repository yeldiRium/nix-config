{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.helm;
  yeldirsCfg = config.yeldirs;
in
{
  options = {
    yeldirs.cli.ops.helm = {
      enable = lib.mkEnableOption "helm";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = yeldirsCfg.cli.ops.kubectl.enable;
        message = "kubectl must be enabled for helm to work";
      }
    ];

    home.packages = with pkgs; [
      (wrapHelm kubernetes-helm {
        plugins = [
          kubernetes-helmPlugins.helm-diff
        ];
      })
    ];
  };
}
