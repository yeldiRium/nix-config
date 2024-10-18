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

      # Source secrets that are mounted via sops
      envExtra = "source ~/.secretenv";
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

  sops = {
    secrets.secretenv = {
      path = "${config.home.homeDirectory}/.secretenv";
    };
  };
}
