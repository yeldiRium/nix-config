{
  config,
  lib,
  ...
}:
let
  cfg = config.yeldirs.desktop.hyprland;
  desktopCfg = config.yeldirs.desktop;

  terminal = lib.getExe config.programs.kitty.package;
in
{
  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    assertions = [
      {
        assertion = config.programs.kitty.enable;
        message = "hyprland bindings assume kitty is installed! either change bindings or install kitty.";
      }
    ];

    wayland.windowManager.hyprland.extraConfig = # lua
      ''
        hl.bind("SUPER + Return", hl.dsp.exec_cmd("${terminal}"))
      '';
  };
}
