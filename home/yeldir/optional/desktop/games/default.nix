{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bottles.nix
    ./heroic.nix
    ./lutris.nix
    ./minecraft.nix
    ./osu.nix
    ./protonup.nix
    ./steam.nix
  ];

  home.packages = with pkgs; [
    gamescope
    minigalaxy
  ];

  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
      allowOther = true;
      directories = [
        ".local/share/applications" # For application .desktop files
        "Games"
      ];
    };
  };
}
