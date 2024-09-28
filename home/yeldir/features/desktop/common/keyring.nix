{
  config,
  lib,
  pkgs,
  ...
}: {
  services.gnome-keyring.enable = true;

  xdg.portal.configPackages = [
    pkgs.gnome.gnome-keyring
  ];

  home = {
    packages = with pkgs; [
      gnome.seahorse
    ];

    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".local/share/keyrings"
        ];
      };
    };
  };
}
