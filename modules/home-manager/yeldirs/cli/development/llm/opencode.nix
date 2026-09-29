{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.development.llm.opencode;
in
{
  options = {
    yeldirs.cli.development.llm.opencode = {
      enable = lib.mkEnableOption "opencode";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        unstable.opencode
      ];

      persistence = {
        "/persist" = {
          directories = [
            ".config/opencode"
          ];
        };
      };
    };
  };
}
