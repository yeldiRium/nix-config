{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.gaming.nostromo;
in
{
  options = {
    yeldirs.gaming.nostromo = {
      enable = lib.mkEnableOption "razer nostromo";
    };
  };

  config = lib.mkIf cfg.enable {
    services.input-remapper = {
      enable = true;
      enableUdevRules = true;
      package = pkgs.unstable.input-remapper;
    };
  };
}
