{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    vlc
  ];

  home.persistence = {
    "/persist" = {
      directories = [
        ".config/vlc"
      ];
    };
  };
}
