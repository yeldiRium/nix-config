{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.common.global.sops;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options = {
    yeldirs.common.global.sops = {
      enable = lib.mkEnableOption "sops";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
    ];
    environment.sessionVariables = {
      SOPS_AGE_KEY_FILE = "/persist/sops/age/keys.txt";
    };
    sops = {
      defaultSopsFile = ../secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = "/persist/sops/age/keys.txt";
    };
  };
}
