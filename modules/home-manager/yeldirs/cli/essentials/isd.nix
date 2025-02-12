{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.isd;
  yeldirsCfg = config.yeldirs;
in {
  options = {
    yeldirs.cli.essentials.isd = {
      enable = lib.mkEnableOption "isd";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = yeldirsCfg.system.platform == "linux";
        message = "isd can only be installed on linux";
      }
    ];

    home.packages = with pkgs; [
      inputs.isd.packages.x86_64-linux.default
    ];
  };
}
