{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.crossplane;
in
{
  options = {
    yeldirs.cli.ops.crossplane = {
      enable = lib.mkEnableOption "crossplane";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      crossplane-cli
    ];
  };
}
