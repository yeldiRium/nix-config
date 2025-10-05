{ pkgs, ... }:
{
  imports = [
    ../shared
    ./shared
    ./shared/darwin

    ../yeldir/optional/desktop/office/hledger.nix
  ];

  wallpaper = pkgs.wallpapers.cyberpunk-rainy-alley;

  yeldirs = {
    system = {
      hostName = "rekorder";
    };

    cli = {
      essentials = {
        neovim = {
          supportedLanguages = [
            "go"
          ];
        };
      };

      development = {
        pre-commit.enable = true;
      };

      media = {
        rss.enable = true;
      };

      ops = {
        nix.enable = true;
      };
    };
  };

  home = {
    stateVersion = "24.05";
  };
}
