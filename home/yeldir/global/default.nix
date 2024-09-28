{config, ...}: {
  home = {
    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        allowOther = true;
      };
    };
  };
}
