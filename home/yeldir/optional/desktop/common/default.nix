{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./filemanager.nix
    ./font.nix
    ./gtk.nix
    ./kitty.nix
    ./networkmanager.nix
    ./volumecontrol.nix
    ./wireplumber.nix
  ];

  home.packages = with pkgs; [
    libnotify

    d-spy
  ];

  # Also sets org.freedesktop.appearance color-scheme
  dconf.settings."org/gnome/desktop/interface".color-scheme =
    if config.colorscheme.mode == "dark"
    then "prefer-dark"
    else if config.colorscheme.mode == "light"
    then "prefer-light"
    else "default";

  xdg.portal.enable = true;
}
