
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.office.yt-dlp;
in {
  options = {
    yeldirs.cli.office.yt-dlp = {
      enable = lib.mkEnableOption "yt-dlp";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      yt-dlp
    ];
  };
}
