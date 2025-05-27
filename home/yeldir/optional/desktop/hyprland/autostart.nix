{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.yeldirs.hyprland.autostart;
in {
  options = {
    yeldirs.hyprland.autostart = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            workspace = mkOption {
              type = types.nullOr types.str;
              example = "1";
              default = null;
            };
            selector = mkOption {
              type = types.nullOr types.str;
              example = "class:org.telegram.desktop";
              default = null;
            };
            command = mkOption {
              type = types.str;
              example = "gtk-launch org.telegram.desktop";
            };
          };
        }
      );
      default = [];
    };
  };
  config = {
    assertions =
      map (rule: {
        assertion = (rule.workspace == null && rule.selector == null) || (rule.workspace != null && rule.selector != null);
        message = "Autostart rule for ${rule.command} is invalid: The options workspace and selector must either both be set or both be null.";
      })
      cfg;

    wayland.windowManager.hyprland.settings = {
      windowrule = builtins.concatMap (rule:
        if rule.workspace != null && rule.selector != null
        then ["workspace ${rule.workspace} silent, ${rule.selector}"]
        else [])
      cfg;
      exec-once = map (rule: rule.command) cfg;
    };
  };
}
