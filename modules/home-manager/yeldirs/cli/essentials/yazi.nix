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
        package = pkgs.unstable.yazi;

        settings = {
          manager = {
            show_hidden = true;
          };
        };
        keymap = {
          manager = {
            prepend_keymap = [
              { on = "{"; run = "tab_switch -1 --relative"; desc = "Switch to previous tab"; }
              { on = "}"; run = "tab_switch 1 --relative"; desc = "Switch to next tab"; }
              { on = "("; run = "tab_swap -1"; desc = "Swap current tab with previous tab"; }
              { on = ")"; run = "tab_swap 1"; desc = "Swap current tab with next tab"; }
            ];
          };
        };
      };
    };
  };
}
