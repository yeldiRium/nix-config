{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.networking;
in
{
  options = {
    yeldirs.cli.ops.networking = {
      enable = lib.mkEnableOption "networking ops tools";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      dig
    ];
  };
}
