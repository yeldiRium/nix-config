{ pkgs, ... }:
{
  imports = [
    ../shared
    ./shared
    ./shared/darwin
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
