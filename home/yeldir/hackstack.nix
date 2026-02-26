{ lib, pkgs, ... }:
{
  imports = [
    ../shared
    ./shared
    ./shared/linux

    ./optional/desktop/hyprland
  ];

  wallpaper = pkgs.wallpapers.cyberpunk-tree-landscape;

  yeldirs = {
    system = {
      hostName = "hackstack";

      keyboardVariant = "neo";
    };

    desktop = {
      essentials = {
        firefox = {
          enable = true;
          default = true;
        };
        chrome = {
          default = lib.mkForce false;
        };
      };

      office = {
        libreoffice.enable = true;
        obsidian.enable = true;
        thunderbird = {
          enable = true;
          profile = "hannes.leutloff@yeldirium.de";
        };
      };

      media = {
        spotify.enable = true;
        vlc.enable = true;
      };
    };

    # Deprecated non-module options:
    hyprland = {
      enableAnimations = false;
      enableTransparency = false;

      autostart = [
        {
          command = "gtk-launch org.telegram.desktop.desktop";
          workspace = "1";
          selector = "class:org.telegram.desktop";
        }
        {
          command = "gtk-launch zotero";
          workspace = "1";
          selector = "class:Zotero";
        }
        {
          command = "gtk-launch obsidian";
          workspace = "5";
          selector = "class:obsidian";
        }
        {
          command = "gtk-launch thunderbird";
          workspace = "7";
          selector = "class:thunderbird";
        }
        {
          command = "gtk-launch firefox";
          workspace = "3";
          selector = "class:firefox";
        }
      ];
    };
  };

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      position = "0x0";
      primary = true;
    }
    {
      name = "desc:DENON Ltd. DENON-AVR 0x01010101";
      width = 1920;
      height = 1080;
      position = "1920x0";
    }
  ];

  home = {
    stateVersion = "25.05";
  };
}
