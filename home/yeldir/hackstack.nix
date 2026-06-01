{ lib, pkgs, ... }:
{
  imports = [
    ../shared
    ./shared
    ./shared/linux

    ./optional/desktop/common
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

      autostart = [
        {
          command = "gtk-launch org.telegram.desktop.desktop";
          workspace = "1";
          windowClass = "org.telegram.desktop";
        }
        {
          command = "gtk-launch zotero";
          workspace = "1";
          windowClass = "Zotero";
        }
        {
          command = "gtk-launch obsidian";
          workspace = "5";
          windowClass = "obsidian";
        }
        {
          command = "gtk-launch thunderbird";
          workspace = "7";
          windowClass = "thunderbird";
        }
        {
          command = "gtk-launch firefox";
          workspace = "3";
          windowClass = "firefox";
        }
      ];

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

      hyprland = {
        enable = true;
        enableAnimations = false;
        enableTransparency = false;
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
  };

  home = {
    stateVersion = "25.05";
  };
}
