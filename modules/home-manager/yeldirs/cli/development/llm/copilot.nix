{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.development.llm.copilot;
in
{
  options = {
    yeldirs.cli.development.llm.copilot = {
      enable = lib.mkEnableOption "copilot";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        unstable.github-copilot-cli
      ];

      persistence = {
        "/persist" = {
          directories = [
            ".copilot"
          ];
        };
      };
    };
  };
}
