{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli) essentials;
  inherit (config.yeldirs.system) platform;
in
{
  config = lib.mkIf (essentials.enable && platform == "linux") {
    home.packages = with pkgs; [
      inputs.isd.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
