{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.development.claude;
in
{
  options = {
    yeldirs.cli.development.claude = {
      enable = lib.mkEnableOption "claude";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        claude-code
      ];

      persistence = {
        "/persist/${config.home.homeDirectory}" = {
          directories = [
            ".claude"
          ];
        };
      };
    };
  };
}
