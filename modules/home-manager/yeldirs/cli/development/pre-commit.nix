{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.development.pre-commit;
in
{
  options = {
    yeldirs.cli.development.pre-commit = {
      enable = lib.mkEnableOption "pre-commit";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pre-commit
    ];
  };
}
