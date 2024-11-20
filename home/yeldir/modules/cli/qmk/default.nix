{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.qmk;
in {
  options = {
    yeldirs.cli.qmk = {
      enable = lib.mkEnableOption "qmk";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        qmk
        qmk-udev-rules
      ]
      ++ (let
        script = name:
          pkgs.writeTextFile {
            inherit name;
            executable = true;
            destination = "/bin/${name}";
            text = builtins.readFile ./scripts/${name}.sh;
            checkPhase = ''
              ${pkgs.stdenv.shellDryRun} "$target"
            '';
            meta.mainProgram = name;
          };
      in [
        (script "qmk-compile-neo2")
      ]);

    xdg.configFile = {
      "qmk/qmk.ini".source = pkgs.writeText "qmk.ini" (builtins.readFile ./qmk.ini);
    };
  };
}
