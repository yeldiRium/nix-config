{config, ...}: {
  wayland.windowManager.hyprland.settings.exec-once = let
    windowrule = monitor: workspace:
      if monitor == null && workspace && null
      then ""
      else
        "["
        + (
          if monitor == null
          then ""
          else "monitor " + monitor + ";"
        )
        + (
          if workspace == null
          then ""
          else "workspace " + workspace + " silent;"
        )
        + "] ";
  in
    map (m: "${windowrule m.monitor m.workspace}${m.command}") config.autostart;
}
