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

      shellAliases = {
        devs = "devenv shell zsh";
        devt = "devenv test";
        devtb = "devenv tasks run app:build";
        devtl = "devenv tasks run app:lint";
        devtlf = "devenv tasks run app:lint-fix";
      };
    };
  };
}
