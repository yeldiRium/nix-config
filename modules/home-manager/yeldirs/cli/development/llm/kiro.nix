{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.development.llm.kiro;
in
{
  options = {
    yeldirs.cli.development.llm.kiro = {
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
