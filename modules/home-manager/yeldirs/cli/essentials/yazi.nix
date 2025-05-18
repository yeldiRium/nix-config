{
  config,
  lib,
  pkgs,
  ...
}: let
  essentials = config.yeldirs.cli.essentials;
  cfg = config.yeldirs.cli.essentials.yazi;
in {
  options = {
    yeldirs.cli.essentials.yazi = {
      enableGui = lib.mkEnableOption "yazi with graphical ui";
    };
  };

  config = lib.mkIf essentials.enable {
    home = {
      # yazi dependencies
      packages = with pkgs;
        [
          file

          fd
          fzf
          jq
          ripgrep
        ]
        ++ (lib.optionals cfg.enableGui [
          ffmpeg
          imagemagick
          poppler_utils
          resvg
        ]);
    };

    programs = {
      yazi = {
        enable = true;

        settings = {
          manager = {
            show_hidden = true;
          };
        };
      };
    };
  };
}
