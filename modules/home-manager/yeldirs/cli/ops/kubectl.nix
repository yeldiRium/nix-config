{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.kubectl;
in
{
  options = {
    yeldirs.cli.ops.kubectl = {
      enable = lib.mkEnableOption "kubectl";
      aliasOnly = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = lib.mkIf (!cfg.aliasOnly) (
        with pkgs;
        [
          kubectl
          kubectx
          y.konfig
          y.k8s-scripts

          delta
        ]
      );

      persistence = lib.mkIf (!cfg.aliasOnly) {
        "/persist/${config.home.homeDirectory}" = {
          directories = [
            ".kube"
          ];
        };
      };

      sessionVariables = {
        KUBECTL_EXTERNAL_DIFF = "${lib.getExe pkgs.delta} --default-language yaml";
      };

      shellAliases = {
        k = "kubectl";
        kg = "kubectl get";
        kga = "kubectl get -A";
        kgall = "kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found";

        ke = "kubectl edit";
        kes = "kubectl edit --subresource status";

        kd = "kubectl describe";

        kaf = "kubectl apply -f";
        kdf = "kubectl diff -f";
      };
    };

    programs = lib.mkIf (!cfg.aliasOnly) {
      zsh.initContent = lib.mkIf config.programs.zsh.enable ''
        source <(${lib.getExe pkgs.kubectl} completion zsh)
      '';
    };
  };
}
