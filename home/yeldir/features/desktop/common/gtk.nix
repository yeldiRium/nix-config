{pkgs, ...}: {
  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  gtk = {
    enable = true;
    # TODO: lots of ricing
  };
}
