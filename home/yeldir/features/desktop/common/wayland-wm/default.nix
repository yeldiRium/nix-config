{pkgs, ...}: {
  imports = [
    ./mako.nix
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
  };

  xdg.mimeApps.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-wlr
  ];
}
