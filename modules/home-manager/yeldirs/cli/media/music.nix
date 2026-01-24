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
        (pkgs.writeShellScriptBin "id3j" # bash
          ''
            id3 --query '{"title":"%t","artist":"%a","album":"%l","track":"%n","year":"%y","genre":"%g"}' "''${1}"
          ''
        )
      ];
    };
  };
}
