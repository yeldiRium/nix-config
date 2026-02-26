{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.games.minecraft;
in
{
  options = {
    yeldirs.desktop.games.minecraft = {
      enable = lib.mkEnableOption "minecraft";
    };
  };

  config = lib.mkIf cfg.enable {
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
