{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./filemanager.nix
    ./font.nix
    ./gtk.nix
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

  xdg.desktopEntries = {
    "org.gnome.dspy" = {
      name = "D-Spy";
      type = "Application";
      exec = "env GSK_RENDERER=ngl ${lib.getExe pkgs.d-spy}";
      icon = "org.gnome.dspy";
      categories = ["GNOME" "GTK" "Development"];
      terminal = false;
      startupNotify = true;
    };
  };
}
