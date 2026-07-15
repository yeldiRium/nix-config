{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.media.tagstudio;
in
{
  options = {
    yeldirs.desktop.media.tagstudio = {
      enable = lib.mkEnableOption "tagstudio";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home = {
      packages = [
        inputs.tagstudio.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      persistence."/persist" = {
        directories = [
          ".config/TagStudio"
        ];
      };
    };
  };
}
