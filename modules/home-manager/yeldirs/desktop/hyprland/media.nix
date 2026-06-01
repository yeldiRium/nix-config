{
  config,
  pkgs,
  lib,
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
        pactl = lib.getExe' pkgs.pulseaudio "pactl";
        playerctl = lib.getExe' config.services.playerctld.package "playerctl";
        playerctld = lib.getExe' config.services.playerctld.package "playerctld";
      in
      # lua
      ''
        -- volume control using pactl
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${pactl} set-sink-volume @DEFAULT_SINK@ +5%"))
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${pactl} set-sink-volume @DEFAULT_SINK@ -5%"))
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${pactl} set-sink-mute @DEFAULT_SINK@ toggle"))
        hl.bind("SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("${pactl} set-source-volume @DEFAULT_SOURCE@ +5%"))
        hl.bind("SHIFT + XF86AudioLowerVolume", hl.dsp.exec_cmd("${pactl} set-source-volume @DEFAULT_SOURCE@ -5%"))
        hl.bind("SHIFT + XF86AudioMute", hl.dsp.exec_cmd("${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"))
        hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"))

        -- player control using playerctl
        hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${playerctl} next"))
        hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${playerctl} previous"))
        hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${playerctl} play-pause"))
        hl.bind("XF86AudioStop", hl.dsp.exec_cmd("${playerctl} stop"))
        hl.bind("SHIFT + XF86AudioNext", hl.dsp.exec_cmd("${playerctld} shift"))
        hl.bind("SHIFT + XF86AudioPrev", hl.dsp.exec_cmd("${playerctld} unshift"))
        hl.bind("SHIFT + XF86AudioPlay", hl.dsp.exec_cmd("systemctl --user restart playerctld"))
      '';

    home.packages = with pkgs; [ playerctl ];
    services.playerctld = {
      enable = true;
    };
  };
}
