{config, ...}: {
  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
      directories = [
        ".local/state/wireplumber"
      ];
    };
  };
}
