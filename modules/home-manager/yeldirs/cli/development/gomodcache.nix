{
  config,
  lib,
  ...
}:
let
  cfg = config.yeldirs.cli.development.gomodcache;
in
{
  options = {
    yeldirs.cli.development.gomodcache = {
      enable = lib.mkEnableOption "gomodcache";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables = {
        GOMODCACHE = "\${HOME}/go/pkg/mod";
      };
      persistence = {
        "/persist" = {
          directories = [
            "go"
          ];
        };
      };
    };
  };
}
