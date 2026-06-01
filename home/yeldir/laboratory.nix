{ pkgs, ... }:
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
      hostName = "laboratory";
    };

    # Deprecated non-module options.
    desktop = {
      enable = true;

      monitors = [
        {
          name = "LVDS-1";
          width = 1600;
          height = 900;
          workspace = "9";
          position = "1920x800";
        }
      ];

      hyprland = {
        enableAnimations = false;
        enableTransparency = false;
      };
    };
  };

  home = {
    stateVersion = "24.05";
  };
}
