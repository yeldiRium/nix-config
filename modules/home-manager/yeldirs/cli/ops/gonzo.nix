{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.gonzo;
in
{
  options = {
    yeldirs.cli.ops.gonzo = {
      enable = lib.mkEnableOption "gonzo";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.gonzo.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
