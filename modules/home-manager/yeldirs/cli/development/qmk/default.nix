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
    home.packages =
      with pkgs;
      [
        qmk
        qmk-udev-rules
      ]
      ++ (
        let
          script =
            name:
            pkgs.writeTextFile {
              inherit name;
              executable = true;
              destination = "/bin/${name}";
              text = builtins.readFile ./scripts/${name};
              checkPhase = ''
                ${pkgs.stdenv.shellDryRun} "$target"
              '';
              meta.mainProgram = name;
            };
        in
        [
          (script "qmk-compile-ergodox")
          (script "qmk-compile-crkbd-neo2-de")
          (script "qmk-compile-crkbd-neo2-de-macos")
          (script "qmk-flash-ergodox")
          (script "qmk-flash-crkbd-neo2-de")
          (script "qmk-flash-crkbd-neo2-de-macos")
        ]
      );

    xdg.configFile = {
      "qmk/qmk.ini".source = ./qmk.ini;
    };
  };
}
