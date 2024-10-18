{config, ...}: {
  imports = [
    ./lutris.nix
    #./minecraft.nix
    ./steam.nix
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
