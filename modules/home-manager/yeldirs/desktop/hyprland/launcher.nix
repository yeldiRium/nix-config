{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.hyprland;
  desktopCfg = config.yeldirs.desktop;

  rofi = lib.getExe config.programs.rofi.package;
  cliphist = lib.getExe config.services.cliphist.package;

  inherit (inputs.nix-colors.lib.conversions) hexToRGBString;
  inherit (config.colorscheme) colors;
  toRGBA = color: opacity: "rgba ( ${hexToRGBString ", " (lib.removePrefix "#" color)}, ${opacity} )";

  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    wayland.windowManager.hyprland.extraConfig = # lua
      ''
        hl.layer_rule({
          name = "rofi",
          match = {
            namespace = "rofi",
          },
          blur = true,
          ignore_alpha = 0,
          dim_around = true,
        })

        hl.bind("SUPER + Tab", hl.dsp.exec_cmd("${rofi} -show window"))
        hl.bind("SUPER + D", hl.dsp.exec_cmd("${rofi} -show drun -drun-show-actions"))

        hl.bind("SUPER + C", hl.dsp.exec_cmd("selected=$(${cliphist} list | ${rofi} -dmenu) && echo \"''$selected\" | ${cliphist} decode | wl-copy"))
      '';

    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      font = "${config.fontProfiles.regular.name} ${toString config.fontProfiles.regular.size}";
      terminal = "${pkgs.kitty}/bin/kitty";

      theme = {
        "@theme" = "default";
        "*" = {
          "font" = "${config.fontProfiles.regular.name} ${toString config.fontProfiles.regular.size}";
          "spacing" = mkLiteral "2";

          "background" = mkLiteral (toRGBA colors.surface "70 %");
          "lightbg" = mkLiteral (toRGBA colors.surface_bright "70 %");
          "foreground" = mkLiteral (toRGBA colors.on_surface "70 %");
          "lightfg" = mkLiteral (toRGBA colors.on_surface_variant "70 %");

          "separatorcolor" = mkLiteral (toRGBA colors.primary "70 %");

          "red" = mkLiteral (toRGBA colors.error "100 %");
        };
        "window" = {
          "border-color" = mkLiteral "var(separatorcolor)";
          "border-radius" = mkLiteral "0.5 em";
          "transparency" = "real";
        };
        "element" = {
          "children" = [
            (mkLiteral "element-icon")
            (mkLiteral "element-text")
          ];
        };
      };
    };

    services.cliphist = {
      enable = true;
    };
  };
}
