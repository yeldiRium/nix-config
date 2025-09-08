{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    vlc
  ];

  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
      directories = [
        ".config/vlc"
      ];
    };
  };
}
