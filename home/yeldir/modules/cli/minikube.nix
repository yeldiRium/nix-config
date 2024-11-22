{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.minikube;
in {
  options = {
    yeldirs.cli.minikube = {
      enable = lib.mkEnableOption "minikube";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      minikube
    ];

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".minikube"
        ];
      };
    };
  };
}
