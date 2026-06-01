{
  pkgs,
  ...
}:
{
  config = {
    home.packages = with pkgs; [
      gtk3
      hyprpicker
      unstable.hyprland-qtutils
    ];

    wayland.windowManager.hyprland = {
      settings = {
        # Specific window rules for games and applications
        windowrule = [
          {
            name = "steam";
            "match:title" = "^()$";
            "match:class" = "^(steam)$";
            stay_focused = "on";
            min_size = "1 1";
          }
          {
            name = "steam-app";
            "match:class" = "^(steam_app_[0-9]*)$";
            immediate = "on";
          }
        ];
      };
    };
  };
}
