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
      sopsFile = lib.mkOption {
        type = lib.types.path;
        example = "../../secrets.yaml";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.keyFile != "";
        message = "if yeldir's sops home-manager module is enabled, keyFile must be set";
      }
      {
        assertion = cfg.sopsFile != "";
        message = "if yeldir's sops home-manager module is enabled, sopsFile must be set";
      }
    ];

    sops = {
      defaultSopsFile = cfg.sopsFile;
      defaultSopsFormat = "yaml";

      age.keyFile = cfg.keyFile;
    };
  };
}
