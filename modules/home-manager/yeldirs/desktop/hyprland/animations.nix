{
  config,
  lib,
  ...
}:
let
  cfg = config.yeldirs.desktop.hyprland;
  desktopCfg = config.yeldirs.desktop;
in
{
  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    wayland.windowManager.hyprland.extraConfig = # lua
    ''
      hl.config({
        animations = {
          enabled = ${if cfg.enableAnimations then "true" else "false"},
        },
      })
    ''
    +
      lib.optionalString cfg.enableAnimations # lua
        ''
          -- animations
          --- curves
          hl.curve("easein", { type = "bezier", points = {{0.1, 0}, {0.5, 0}}})
          hl.curve("easeinback", { type = "bezier", points = {{0.35, 0}, {0.95, -0.3}}})
          hl.curve("easeout", { type = "bezier", points = {{0.5, 1}, {0.9, 1}}})
          hl.curve("easeoutback", { type = "bezier", points = {{0.35, 1.35}, {0.65, 1}}})
          hl.curve("easeinout", { type = "bezier", points = {{0.45, 0}, {0.55, 1}}})
          --- animations
          hl.animation({
            enabled = true,
            leaf = "fadeIn",
            speed = 3,
            bezier = "easeout",
          })
          hl.animation({
            enabled = true,
            leaf = "fadeLayersIn",
            speed = 3,
            bezier = "easeoutback",
          })
          hl.animation({
            enabled = true,
            leaf = "layersIn",
            speed = 3,
            bezier = "easeoutback",
            style = "slide",
          })
          hl.animation({
            enabled = true,
            leaf = "windowsIn",
            speed = 3,
            bezier = "easeoutback",
            style = "slide",
          })
          hl.animation({
            enabled = true,
            leaf = "fadeLayersOut",
            speed = 3,
            bezier = "easeinback",
          })
          hl.animation({
            enabled = true,
            leaf = "fadeOut",
            speed = 3,
            bezier = "easein",
          })
          hl.animation({
            enabled = true,
            leaf = "layersOut",
            speed = 3,
            bezier = "easeinback",
            style = "slide",
          })
          hl.animation({
            enabled = true,
            leaf = "windowsOut",
            speed = 3,
            bezier = "easeinback",
            style = "slide",
          })
          hl.animation({
            enabled = true,
            leaf = "border",
            speed = 3,
            bezier = "easeout",
          })
          hl.animation({
            enabled = true,
            leaf = "fadeDim",
            speed = 3,
            bezier = "easeinout",
          })
          hl.animation({
            enabled = true,
            leaf = "fadeShadow",
            speed = 3,
            bezier = "easeinout",
          })
          hl.animation({
            enabled = true,
            leaf = "fadeSwitch",
            speed = 3,
            bezier = "easeinout",
          })
          hl.animation({
            enabled = true,
            leaf = "windowsMove",
            speed = 3,
            bezier = "easeoutback",
          })
          hl.animation({
            enabled = true,
            leaf = "workspaces",
            speed = 2.6,
            bezier = "easeoutback",
            style = "slide",
          })
        '';
  };
}
