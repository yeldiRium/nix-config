{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials;
in {
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        devbox
      ];

      shellAliases = {
        drt = "devbox run test";
        drl = "devbox run lint";
        drlf = "devbox run lint:fix";
      };
    };
  };
}
