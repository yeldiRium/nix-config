{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.games.minecraft;
in
{
  options = {
    yeldirs.desktop.games.minecraft = {
      enable = lib.mkEnableOption "minecraft";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      prismlauncher
    ];

    home.persistence = {
      "/persist" = {
        directories = [
          ".local/share/PrismLauncher"
        ];
      };
    };
  };
}
