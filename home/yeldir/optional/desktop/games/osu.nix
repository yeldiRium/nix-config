{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.osu-lazer ];

  home.persistence = {
    "/persist".directories = [ ".local/share/osu" ];
  };
}
