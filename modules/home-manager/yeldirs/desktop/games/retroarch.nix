{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.games.retroarch;
in
{
  options = {
    yeldirs.desktop.games.retroarch = {
      enable = lib.mkEnableOption "retroarch";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        (retroarch.withCores (
          cores: with cores; [
            desmume
          ]
        ))
      ];

      persistence = {
        "/persist/${config.home.homeDirectory}" = {
          directories = [
            ".config/retroarch"
          ];
        };
      };
    };
  };
}
