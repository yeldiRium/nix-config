{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    gnome.gnome-keyring
    gnome.seahorse
  ];
  services.gnome-keyring.enable = true;

  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
      directories = [
        ".local/share/keyrings"
      ];
    };
  };
}
