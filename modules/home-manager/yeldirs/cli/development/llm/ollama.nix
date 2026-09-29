{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.development.llm.ollama;
in
{
  options = {
    yeldirs.cli.development.llm.ollama = {
      enable = lib.mkEnableOption "ollama";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        unstable.ollama-rocm
      ];

      persistence = {
        "/persist" = {
          directories = [
            ".ollama"
          ];
        };
      };
    };
  };
}
