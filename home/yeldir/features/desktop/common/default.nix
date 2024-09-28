{pkgs, ...}: {
  imports = [
    ./gtk.nix
    ./networkmanager.nix
  ];

  home.packages = [pkgs.libnotify];

  xdg.portal.enable = true;
}
