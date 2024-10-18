{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.autostart = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          workspace = mkOption {
            type = types.nullOr types.str;
            example = "1";
          };
          monitor = mkOption {
            type = types.nullOr types.str;
            example = "DP-3";
          };
          command = mkOption {
            type = types.str;
            example = "google-chrome";
          };
        };
      }
    );
    default = [];
  };
}
