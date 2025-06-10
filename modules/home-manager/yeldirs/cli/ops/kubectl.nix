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

      ke = "kubectl edit";
      kes = "kubectl edit --subresource status";

      kd = "kubectl describe";

      kaf = "kubectl apply -f";
      kdf = "kubectl diff -f";
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
