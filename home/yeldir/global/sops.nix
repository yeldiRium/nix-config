{config, inputs, lib, ...}: let 
  cfg = config.yeldirs.sops;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options = {
    yeldirs.sops.keyFile = lib.mkOption {
      type = lib.types.path;
      example = "/persist/sops/age/keys.txt";
    };
  };

  config = {
    sops = {
      defaultSopsFile = ../secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = cfg.keyFile;
    };
  };
}
