{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.ops.kubectl;
in {
  options = {
    yeldirs.cli.ops.kubectl = {
      enable = lib.mkEnableOption "kubectl";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kubectl
    ];

    home.shellAliases = {
      k = "kubectl";
      kg = "kubectl get";
      kga = "kubectl get -A";
    };

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".kube"
        ];
      };
    };
  };
}
