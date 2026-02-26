{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.games.retroarch;
in
{
  options = {
    yeldirs.desktop.games.retroarch = {
      enable = lib.mkEnableOption "retroarch";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home = {
      packages = with pkgs; [
        (retroarch.withCores (
          cores: with cores; [
            desmume # nds
            mgba # gba
            ppsspp # psp, requires manual [bios setup](https://docs.libretro.com/library/ppsspp/#installing-from-the-core-system-files-downloader)
            pcsx2 # ps2, requires manual [GameIndex.yaml](https://docs.libretro.com/library/lrps2/#core-system-files-downloader) and [bios setup](https://docs.libretro.com/library/lrps2/#bios)
          ]
        ))
      ];

      persistence = {
        "/persist" = {
          directories = [
            ".config/retroarch"
          ];
        };
      };
    };
  };
}
