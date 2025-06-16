{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.system.sops;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options = {
    yeldirs.system.sops = {
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
      defaultSopsFile = ../../../../hosts/shared/secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = "/persist/sops/age/keys.txt";
    };
  };
}
