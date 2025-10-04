{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials;
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        unstable.devenv
      ];
    };
  };
}
