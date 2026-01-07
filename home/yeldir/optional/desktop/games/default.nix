{
  pkgs,
  ...
}:
{
  imports = [
    ./bottles.nix
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
    "/persist" = {
      directories = [
        ".local/share/applications" # For application .desktop files
        ".config/minigalaxy"
        "Games"
      ];
    };
  };
}
