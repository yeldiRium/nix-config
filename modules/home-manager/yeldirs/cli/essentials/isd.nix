{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  essentials = config.yeldirs.cli.essentials;
  platform = config.yeldirs.system.platform;
in {
  config = lib.mkIf (essentials.enable && platform == "linux") {
    home.packages = with pkgs; [
      inputs.isd.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
