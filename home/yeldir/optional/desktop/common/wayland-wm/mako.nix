{config, ...}: let
  inherit (config.colorscheme) colors mode;
in {
  services = {
    mako = {
      enable = true;
      settings = {
        iconPath =
          if mode == "dark"
          then "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark"
          else "${config.gtk.iconTheme.package}/share/icons/Papirus-Light";
        font = "${config.fontProfiles.regular.name} ${toString config.fontProfiles.regular.size}";
        padding = "10,20";
        anchor = "top-center";
        width = 400;
        height = 150;
        borderSize = 2;
        defaultTimeout = 12000;
        backgroundColor = "${colors.surface}dd";
        borderColor = "${colors.secondary}dd";
        textColor = "${colors.on_surface}dd";
        layer = "overlay";
        maxHistory = 50;
      };
    };
  };
}
