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

  rgba = color: alpha: "rgba(${lib.removePrefix "#" color}${alpha})";
  activeAlpha = "ff";
  inactiveAlpha = if cfg.enableTransparency then "aa" else "ff";
in
{
  imports = [
    ./animations.nix
    ./autostart.nix
    ./clipboard.nix
    ./launcher.nix
    ./media.nix
    ./notifications.nix
    ./screenshot.nix
    ./system.nix
    ./statusbar.nix
    ./terminal.nix
    ./wallpaper.nix
  ];

  options = {
    yeldirs.desktop.hyprland = {
      enable = lib.mkEnableOption "hyprland";

      enableAnimations = lib.mkOption {
        type = lib.types.bool;
        description = "Enable hyprland animations";
        default = true;
      };
      enableTransparency = lib.mkOption {
        type = lib.types.bool;
        description = "Enable hyprland transparency";
        default = true;
      };
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      plugins = [
        inputs.hy3.packages.${pkgs.stdenv.hostPlatform.system}.hy3
      ];
      systemd = {
        enable = true;
        enableXdgAutostart = true;
      };
      configType = "lua";

      extraConfig = # lua
        ''
          -- constants
          border_radius = 0
          border_size = 2
          gap_size_in = 8
          gap_size_out = 12
          --- colors
          colors = {
            primary = "${rgba config.colorscheme.colors.primary "aa"}",
            surface = "${rgba config.colorscheme.colors.surface "aa"}",
          }
          --- workspaces
          workspaces = {
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
          }
          --- workspaces and their shifted keys
          --- meaning without shift the workspace name is its binding, with shift the shifted key
          -- workspaces = {
          --   ["1"] = "exclam",
          --   ["2"] = "quotedbl",
          --   ["3"] = "paragraph",
          --   ["4"] = "dollar",
          --   ["5"] = "percent",
          --   ["6"] = "ampersand",
          --   ["7"] = "slash",
          --   ["8"] = "parenleft",
          --   ["9"] = "parenright",
          -- }
          --- keybinds
          directions = {
            Left = "l",
            I = "l",
            Right = "r",
            E = "r",
            Up = "u",
            L = "u",
            Down = "d",
            A = "d",
          }

          hl.config({
            general = {
              border_size = borderSize,
              gaps_in = gap_size_in,
              -- gaps_out is set later in the monitors section to respect the monitorsReservedArea
              col = {
                active_border = colors.primary,
                inactive_border = colors.surface,
              },
              layout = "master", -- overwritten by hy3 below

              -- Tearing seems to freeze steam games in fullscreen with AMD GPUs
              -- https://github.com/hyprwm/Hyprland/issues/5097
              allow_tearing = false,
            },
            decoration = {
              rounding = border_radius,
              active_opacity = 1.0,
              inactive_opacity = 1.0,
              fullscreen_opacity = 1.0,
              blur = {
                enabled = ${if cfg.enableTransparency then "true" else "false"},
                size = 4,
                passes = 1,
                ignore_opacity = true,
                new_optimizations = true,
                popups = true,
              },
              shadow = {
                enabled = true,
                range = 12,
                offset = "3 3",
              },
            },
            input = {
              kb_layout = "${config.yeldirs.system.keyboardLayout}",
              kb_variant = "${config.yeldirs.system.keyboardVariant}",

              -- correct resolving of keybinds with multilayer and multilayout input devices
              resolve_binds_by_sym = true,

              -- linear mouse motion
              accel_profile = "flat",

              touchpad = {
                disable_while_typing = false,
              },
            },
            group = {
              col = {
                border_active = colors.primary,
                border_inactive = colors.surface,
              },
              groupbar = {
                font_size = 11,
              },
            },
            misc = {
              disable_hyprland_logo = true,
            },
            binds = {
              workspace_back_and_forth = true,
            },
            ecosystem = {
              no_update_news = true,
            },
            debug = {
              disable_logs = false,
            },
          })

          -- hy3 and window management bindings
          if hl.plugin.hy3 ~= nil then
            hy3 = hl.plugin.hy3
            hl.config({
              general = {
                layout = "hy3",
              },
              plugin = {
                hy3 = {
                  tabs = {
                    height = 20;
                    blur = ${if cfg.enableTransparency then "true" else "false"};
                    padding = gap_size_in;
                    border_width = borderSize;
                    radius = borderRadius;
                    text_font = "${config.fontProfiles.regular.name}";
                    text_padding = 6;
                    text_center = false;
                    text_height = 10;

                    colors = {
                      active = "${rgba config.colorscheme.colors.primary_container activeAlpha}",
                      active_text = "${rgba config.colorscheme.colors.on_primary_container activeAlpha}",
                      active_border = "${rgba config.colorscheme.colors.primary "aa"}",

                      urgent = "${rgba config.colorscheme.colors.tertiary_container inactiveAlpha}",
                      urgent_text = "${rgba config.colorscheme.colors.on_tertiary_container inactiveAlpha}",
                      urgent_border = "${rgba config.colorscheme.colors.tertiary "aa"}",

                      inactive = "${rgba config.colorscheme.colors.surface inactiveAlpha}",
                      inactive_text = "${rgba config.colorscheme.colors.on_surface inactiveAlpha}",
                      inactive_border = "${rgba config.colorscheme.colors.surface "aa"}",
                    },
                  },
                },
              },
            })

            -- moving focus
            for key, value in ipairs(workspaces) do
              hl.bind("SUPER + "..value, hl.dsp.focus({
                workspace = value,
              }))
            end

            -- moving windows to workspaces
            for key, value in ipairs(workspaces) do
              hl.bind("SUPER + SHIFT + "..value, hy3.move_to_workspace(value))
            end
            -- moving windows directionally
            for key, direction in pairs(directions) do
              hl.bind("SUPER + "..key, hy3.move_focus(direction))
              hl.bind("SUPER + SHIFT + "..key, hy3.move_window(direction))
            end
            -- moving floating windows with the mouse
            hl.config({
              binds = { drag_threshold = 10 },
            })
            hl.bind("ALT + mouse:272", hl.dsp.window.drag(), {
              mouse = true, drag = true,
            })

            -- resizing window
            hl.bind("SUPER + R", hl.dsp.submap("resize"))
            hl.define_submap("resize", function()
              hl.bind("escape", hl.dsp.submap("reset"))

              hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true, }), { repeating = true })
              hl.bind("E", hl.dsp.window.resize({ x = 10, y = 0, relative = true, }), { repeating = true })
              hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true}), { repeating = true })
              hl.bind("I", hl.dsp.window.resize({ x = -10, y = 0, relative = true}), { repeating = true })
              hl.bind("up", hl.dsp.window.resize({ x = 0, y = 10, relative = true}), { repeating = true })
              hl.bind("L", hl.dsp.window.resize({ x = 0, y = 10, relative = true}), { repeating = true })
              hl.bind("down", hl.dsp.window.resize({ x = 0, y = -10, relative = true}), { repeating = true })
              hl.bind("A", hl.dsp.window.resize({ x = 0, y = -10, relative = true}), { repeating = true })
            end)

            -- moving workspaces
            hl.bind("SUPER + SHIFT + U", hl.dsp.workspace.move({
              monitor = "l",
            }))
            hl.bind("SUPER + SHIFT + home", hl.dsp.workspace.move({
              monitor = "l",
            }))
            hl.bind("SUPER + SHIFT + O", hl.dsp.workspace.move({
              monitor = "r",
            }))
            hl.bind("SUPER + SHIFT + end", hl.dsp.workspace.move({
              monitor = "r",
            }))

            -- quitting apps
            hl.bind("SUPER + Q", hy3.kill_active())

            -- adjusting layout
            hl.bind("SUPER + Space", hl.dsp.window.float({
              action = "toggle",
            }))
            hl.bind("SUPER + F", hl.dsp.window.fullscreen({
              action = "toggle",
            }))
            hl.bind("SUPER + T", hy3.make_group("tab"))
            hl.bind("SUPER + V", hy3.make_group("v"))
            hl.bind("SUPER + H", hy3.make_group("h"))
            hl.bind("SUPER + S", hy3.change_focus("raise"))
            hl.bind("SUPER + SHIFT + S", hy3.change_focus("lower"))
          end

          -- monitors
          reserved_area_position = "${config.yeldirs.desktop.monitorsReservedArea.position}"
          reserved_area_height = "${toString config.yeldirs.desktop.monitorsReservedArea.height}"
          reserved_area_width = "${toString config.yeldirs.desktop.monitorsReservedArea.width}"
          gaps_out = {
            top = gap_size_out,
            bottom = gap_size_out,
            left = gap_size_out,
            right = gap_size_out,
          }
          if reserved_area_position == "top" then
            gaps_out.top = 2 * gap_size_out + reserved_area_height - gap_size_in
          elseif reserved_area_position == "bottom" then
            gaps_out.bottom = 2 * gap_size_out + reserved_area_height - gap_size_in
          elseif reserved_area_position == "left" then
            gaps_out.left = 2 * gap_size_out + reserved_area_width - gap_size_in
          else
            gaps_out.right = 2 * gap_size_out + reserved_area_width - gap_size_in
          end

          hl.config({
            general = {
              gaps_out = gaps_out,
            },
          })

          ${lib.strings.concatMapStrings (
            m:
            if m.enabled then
              # lua
              ''
                hl.monitor({
                  output = "${m.name}",
                  mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}",
                  position = "${m.position}",
                  transform = ${toString m.transform},
                })
              ''
            else
              # lua
              ''
                hl.monitor({
                  output = "${m.name}",
                  disabled = true,
                })
              ''
          ) config.yeldirs.desktop.monitors}

          --- bind monitors to workspaces
          ${lib.strings.concatMapStrings (
            m: # lua
            ''
              hl.workspace_rule({
                workspace = "${m.workspace}",
                monitor = "${m.name}",
              })
            '') (lib.filter (m: m.enabled && m.workspace != null) desktopCfg.monitors)}

          --- default monitor setup to easily attach external monitors
          hl.monitor({
            output = "",
            mode = "preferred",
            position = "auto",
            scale = 1,
          })

          -- Set my custom keyboards fix to de layout without variant
          keyboard_devices = {
            "zsa-technology-labs-inc-ergodox-ez",
            "zsa-technology-labs-inc-ergodox-ez-keyboard",
            "zsa-technology-labs-inc-ergodox-ez-system-control",
            "zsa-technology-labs-inc-ergodox-ez-consumer-control",
            "foostan-corne",
            "foostan-corne-keyboard",
            "toucan-keyboard",
          }
          for index, value in ipairs(keyboard_devices) do
            hl.device({
              name = value,
              kb_layout = "de",
              kb_variant = "",
            })
          end

          -- load cursor config
          hl.on("hyprland.start", function ()
            hl.exec_cmd("hyprctl setcursor ${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}")
          end)
        '';
    };

    xdg.portal.config.hyprland.default = [
      "hyprland"
      "gtk"
    ];
  };
}
