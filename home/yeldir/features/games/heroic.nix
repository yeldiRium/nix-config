{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    heroic
  ];

  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
      directories = [
        ".config/heroic"
      ];
    };
  };
}
