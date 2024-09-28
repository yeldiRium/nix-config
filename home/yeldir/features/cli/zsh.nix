{config, ...}: {
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "wd"
        ];
      };
    };
  };

  home = {
    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        files = [
          ".warprc"
          ".zsh_history"
        ];
      };
    };
  };
}
