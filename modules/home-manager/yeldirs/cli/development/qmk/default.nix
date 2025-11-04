{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.development.qmk;
in
{
  options = {
    yeldirs.cli.development.qmk = {
      enable = lib.mkEnableOption "qmk";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      qmk
      qmk-udev-rules
      (y.shellScript ./scripts/qmk-compile-ergodox)
      (y.shellScript ./scripts/qmk-compile-crkbd-neo2-de)
      (y.shellScript ./scripts/qmk-compile-crkbd-neo2-de-macos)
      (y.shellScript ./scripts/qmk-flash-ergodox)
      (y.shellScript ./scripts/qmk-flash-crkbd-neo2-de)
      (y.shellScript ./scripts/qmk-flash-crkbd-neo2-de-macos)
    ];

    xdg.configFile = {
      "qmk/qmk.ini".source = ./qmk.ini;
    };
  };
}
