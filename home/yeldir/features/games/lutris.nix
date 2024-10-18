{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    lutris
  ];

  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
      allowOther = true;
      directories = [
        ".local/share/lutris"
      ];
    };
  };
}
