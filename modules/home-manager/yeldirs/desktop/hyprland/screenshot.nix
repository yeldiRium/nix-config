{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.hyprland;
  desktopCfg = config.yeldirs.desktop;

in
{
  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    wayland.windowManager.hyprland.extraConfig =
      let
        grimblast = lib.getExe pkgs.grimblast;
      in
      # lua
      ''
        hl.bind("SUPER + M", hl.dsp.exec_cmd("${grimblast} --notify --freeze copy area"))
        hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("${grimblast} --notify --freeze copy output"))
      '';

    home.packages = with pkgs; [
      grimblast
    ];
  };
}
