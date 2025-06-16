{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.ops.nix;
in {
  options = {
    yeldirs.cli.ops.nix = {
      enable = lib.mkEnableOption "nix ops tools";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nixos-anywhere
    ];
  };
}
