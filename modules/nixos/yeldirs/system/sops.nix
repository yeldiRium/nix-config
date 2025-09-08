{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.system.sops;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options = {
    yeldirs.system.sops = {
      enable = lib.mkEnableOption "sops";
      keyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
    ];
    environment.sessionVariables = {
      SOPS_AGE_KEY_FILE =
        if builtins.isNull cfg.keyFile then "/persist/sops/age/keys.txt" else cfg.keyFile;
    };
    sops = {
      defaultSopsFile = ../../../../hosts/shared/secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = if builtins.isNull cfg.keyFile then "/persist/sops/age/keys.txt" else cfg.keyFile;
    };
  };
}
