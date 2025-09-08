{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    libreoffice-fresh
  ];

  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
      directories = [
        ".config/libreoffice"
      ];
    };
  };
}
