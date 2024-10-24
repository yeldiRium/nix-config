{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    calibre
  ];

  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".config/calibre"
    ];
  };
}
