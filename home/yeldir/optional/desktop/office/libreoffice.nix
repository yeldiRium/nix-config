{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    libreoffice-fresh
  ];

  home.persistence = {
    "/persist" = {
      directories = [
        ".config/libreoffice"
      ];
    };
  };
}
