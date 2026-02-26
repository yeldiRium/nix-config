{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.games.osu;
in
{
  options = {
    yeldirs.desktop.games.osu = {
      enable = lib.mkEnableOption "osu";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.osu-lazer ];

    home.persistence = {
      "/persist".directories = [ ".local/share/osu" ];
    };
  };
}
