{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    gnome-keyring
    seahorse
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
