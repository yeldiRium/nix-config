{pkgs, ...}: {
  imports = [
    ../shared
    ./shared
    ./shared/darwin
  ];

  wallpaper = pkgs.wallpapers.cyberpunk-rainy-alley;

  yeldirs = {
    system = {
      hostName = "rekorder";

      sops = {
        enable = true;
        sopsFile = ./secrets.yaml;
        keyFile = "/Users/yeldir/querbeet/keys.txt";
      };
    };

    cli = {
      essentials = {
        neovim = {
          supportedLanguages = [
            "go"
          ];
        };
      };

      ops = {
        colima.enable = true;
        lazydocker.enable = true;
        nix.enable = true;
      };
    };
  };

  home = {
    stateVersion = "24.05";
  };
}
