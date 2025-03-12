{
  pkgs,
  ...
}: {
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

      ops = {
        colima.enable = true;
        lazydocker.enable = true;
      };
    };
  };

  home = {
    stateVersion = "24.05";
  };
}
