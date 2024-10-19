{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./lutris.nix
    ./minecraft.nix
    ./protonup.nix
    ./steam.nix
  ];

  home.packages = with pkgs; [
    gamescope
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
