{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./font.nix
    ./gtk.nix
    ./networkmanager.nix
    ./pavucontrol.nix
  ];

  home.packages = [pkgs.libnotify];

  # Also sets org.freedesktop.appearance color-scheme
  dconf.settings."org/gnome/desktop/interface".color-scheme =
    if config.colorscheme.mode == "dark"
    then "prefer-dark"
    else if config.colorscheme.mode == "light"
    then "prefer-light"
    else "default";

  xdg.portal.enable = true;
}
