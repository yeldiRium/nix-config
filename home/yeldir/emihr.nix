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
      hostName = "emihr";

      mounts = {
        datengrab.enable = true;
      };
    };

    cli = {
      ops = {
        nix.enable = true;
      };
    };

    desktop = {
      enable = true;

      essentials = {
        firefox = {
          enable = true;
          default = true;
        };
        chrome = {
          default = lib.mkForce false;
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
      ];

      hyprland = {
        enable = true;
        enableAnimations = false;
        enableTransparency = false;
      };

      games = {
        minecraft.enable = true;
      };
    };
  };

  home = {
    stateVersion = "26.05";
  };
}
