{pkgs, ...}: {
  imports = [
    ./gtk.nix
    ./networkmanager.nix
    ./pavucontrol.nix
  ];

  home.packages = [pkgs.libnotify];

  xdg.portal.enable = true;
}
