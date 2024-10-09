{pkgs, ...}: {
  imports = [
    ./cliphist.nix
    ./mako.nix
    ./playerctl.nix
    ./rofi.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home.sessionVariables = {
    # Makes firefox use wayland directly, improves performance.
    MOZ_ENABLE_WAYLAND = 1;
    # Makes QT applications use wayland.
    QT_QPA_PLATFORM = "wayland";
    # Idk what this does yet.
    LIBSEAT_BACKEND = "logind";
    # Make electron based apps use wayland.
    NIXOS_OZONE_WL = "1";
  };

  xdg.mimeApps.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-wlr
  ];

  home.packages = with pkgs; [
    wl-clipboard
  ];
}
