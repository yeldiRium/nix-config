{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli) essentials;
  cfg = config.yeldirs.cli.essentials.yazi;
in
{
  options = {
    yeldirs.cli.essentials.yazi = {
      enableGui = lib.mkEnableOption "yazi with graphical ui";
      enablePersistentCaching = lib.mkEnableOption "yazi with persistent caching";
    };
  };

  config = lib.mkIf essentials.enable {
    home = {
      # yazi dependencies
      packages =
        with pkgs;
        [
          file

          fd
          fzf
          jq
          ripgrep
        ]
        ++ (lib.optionals cfg.enableGui [
          ffmpeg
          mediainfo
          imagemagick
          poppler-utils
          resvg
        ]);

      persistence = lib.mkIf cfg.enablePersistentCaching {
        "/persist" = {
          directories = [
            ".cache/yazi"
          ];
        };
      };
    };

    programs = {
      yazi = {
        enable = true;
        package = pkgs.unstable.yazi;

        settings = {
          mgr = {
            show_hidden = true;
          };
          preview = lib.mkIf cfg.enablePersistentCaching {
            cache_dir = "$XDG_CACHE_HOME/yazi";
          };
        };
        keymap = {
          mgr = {
            prepend_keymap = [
              {
                on = "{";
                run = "tab_switch -1 --relative";
                desc = "Switch to previous tab";
              }
              {
                on = "}";
                run = "tab_switch 1 --relative";
                desc = "Switch to next tab";
              }
              {
                on = "(";
                run = "tab_swap -1";
                desc = "Swap current tab with previous tab";
              }
              {
                on = ")";
                run = "tab_swap 1";
                desc = "Swap current tab with next tab";
              }
            ];
          };
        };
      };
    };
  };
}
