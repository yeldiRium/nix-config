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
    home.packages = with pkgs; [
      gtk3
    ];

    wayland.windowManager.hyprland.extraConfig = lib.strings.concatMapStrings (
      rule:
      if rule.workspace != null && rule.windowClass != null then
        # lua
        ''
          hl.window_rule({
            match = {
              class = "${rule.windowClass}",
            },
            workspace = "${rule.workspace}",
          })

          hl.on("hyprland.start", function ()
            hl.exec_cmd("${rule.command}")
          end)
        ''
      else
        ""
    ) desktopCfg.autostart;
  };
}
