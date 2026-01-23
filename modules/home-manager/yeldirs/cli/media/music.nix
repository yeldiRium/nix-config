{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.media.music;
in
{
  options = {
    yeldirs.cli.media.music = {
      enable = lib.mkEnableOption "music utilities for hearing and sorting";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        id3
      ];

      shellAliases = {
        # Todo: convert into executable so that it can be used in scripts
        id3j = ''id3 --query '{"title":"%t","artist":"%a","album":"%l","track":"%n","year":"%y","genre":"%g"}' '';
      };
    };
  };
}
