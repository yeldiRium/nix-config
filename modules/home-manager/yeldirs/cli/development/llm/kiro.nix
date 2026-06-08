{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.development.kiro;
in
{
  options = {
    yeldirs.cli.development.kiro = {
      enable = lib.mkEnableOption "kiro";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        kiro-cli
      ];

      persistence = {
        "/persist" = {
          directories = [
            ".kiro"
          ];
        };
      };
    };
  };
}
