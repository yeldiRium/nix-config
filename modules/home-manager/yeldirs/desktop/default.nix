{ config, lib, ... }:
let
  cfg = config.yeldirs.desktop;
in
{
  imports = [
    ./communication
    ./essentials
    ./games
    ./hyprland
    ./media
    ./office
  ];

  options = {
    yeldirs.desktop = {
      enable = lib.mkEnableOption "desktop";

      autostart = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              workspace = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                example = "1";
                default = null;
              };
              windowClass = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                example = "org.telegram.desktop";
                default = null;
              };
              command = lib.mkOption {
                type = lib.types.str;
                example = "gtk-launch org.telegram.desktop";
              };
            };
          }
        );
        default = [ ];
      };

      monitors = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                example = "DP-1";
              };
              primary = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              width = lib.mkOption {
                type = lib.types.int;
                example = 1920;
              };
              height = lib.mkOption {
                type = lib.types.int;
                example = 1080;
              };
              refreshRate = lib.mkOption {
                type = lib.types.int;
                default = 60;
              };
              position = lib.mkOption {
                type = lib.types.str;
                default = "auto";
              };
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
              workspace = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              transform = lib.mkOption {
                type = lib.types.int;
                default = 0;
                description = "Hyprland monitor transform enum, https://wiki.hypr.land/Configuring/Basics/Monitors/#rotating";
              };
            };
          }
        );
        default = [ ];
      };

      monitorsReservedArea = lib.mkOption {
        description = "Reserved area for each monitor. Top/bottom bar spans entire width and left/right bar spans entire height.";
        type = lib.types.submodule {
          options = {
            position = lib.mkOption {
              type = lib.types.enum [
                "top"
                "bottom"
                "left"
                "right"
              ];
              default = "top";
            };
            height = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = "Reserved area hight in px";
            };
            width = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = "Reserved area width in px";
            };
          };
        };
      };
    };
  };

  config = {
    assertions =
      # valid autostart rules
      map (rule: {
        assertion =
          (rule.workspace == null && rule.windowClass == null)
          || (rule.workspace != null && rule.windowClass != null);
        message = "Autostart rule for ${rule.command} is invalid: The options workspace and windowClass must either both be set or both be null.";
      }) cfg.autostart

      # valid monitor configurations
      ++ [
        {
          assertion =
            ((lib.length cfg.monitors) != 0) -> ((lib.length (lib.filter (m: m.primary) cfg.monitors)) == 1);
          message = "Exactly one monitor must be set to primary.";
        }

        # valid monitors reserved area values
        {
          assertion = cfg.monitorsReservedArea.position != "top" || cfg.monitorsReservedArea.width == 0;
          message = "If position is top, only height must be supplied.";
        }
        {
          assertion = cfg.monitorsReservedArea.position != "bottom" || cfg.monitorsReservedArea.width == 0;
          message = "If position is bottom, only height must be supplied.";
        }
        {
          assertion = cfg.monitorsReservedArea.position != "left" || cfg.monitorsReservedArea.width == 0;
          message = "If position is left, only width must be supplied.";
        }
        {
          assertion = cfg.monitorsReservedArea.position != "right" || cfg.monitorsReservedArea.width == 0;
          message = "If position is right, only width must be supplied.";
        }
      ];
  };
}
