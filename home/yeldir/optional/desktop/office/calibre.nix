{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    calibre
  ];

  home.persistence."/persist" = {
    directories = [
      ".config/calibre"
    ];
  };
}
