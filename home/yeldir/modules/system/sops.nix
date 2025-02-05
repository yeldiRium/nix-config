{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.yeldirs.system.sops;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options = {
    yeldirs.system.sops = {
      enable = lib.mkEnableOption "sops home module";
      keyFile = lib.mkOption {
        type = lib.types.path;
        example = "/persist/sops/age/keys.txt";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = ../../secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = cfg.keyFile;
    };
  };
}
