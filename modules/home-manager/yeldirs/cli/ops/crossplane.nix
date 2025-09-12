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
      (pkgs.runCommand "crank" {} ''
        mkdir -p "$out/bin"
        ln -s "${pkgs.crossplane-cli}/bin/crossplane" "$out/bin/crank"
      '')
      crossplane-cli
    ];
  };
}
