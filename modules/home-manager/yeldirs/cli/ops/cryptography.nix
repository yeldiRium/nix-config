{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.cryptography;
in
{
  options = {
    yeldirs.cli.ops.cryptography = {
      enable = lib.mkEnableOption "cryptography";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      openssl
    ];
  };
}
