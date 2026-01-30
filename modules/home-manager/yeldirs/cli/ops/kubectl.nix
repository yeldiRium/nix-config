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
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        kubectl
        kubectx
        y.konfig
        y.k8s-scripts

        delta
        (pkgs.writeShellScriptBin "kunfinalize" # bash
          ''
            kubectl patch --type=merge --patch '{"metadata":{"finalizers":null}}' $@
          ''
        )
      ];

      persistence = {
        "/persist" = {
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

    programs = {
      zsh.initContent = lib.mkIf config.programs.zsh.enable ''
        source <(${lib.getExe pkgs.kubectl} completion zsh)
      '';
    };
  };
}
