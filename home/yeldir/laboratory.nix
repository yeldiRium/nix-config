{ pkgs, ... }:
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
      hostName = "laboratory";
    };

    # Deprecated non-module options.
    hyprland = {
      enableAnimations = false;
      enableTransparency = false;
    };
  };

  monitors = [
    {
      name = "LVDS-1";
      width = 1600;
      height = 900;
      workspace = "9";
      position = "1920x800";
    }
  ];

  home = {
    stateVersion = "24.05";
  };
}
