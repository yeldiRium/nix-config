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

  targets.darwin = {
    defaults = {
      "com.apple.dock" = {
        autohide = true;
      };
      "com.apple.menuextra.battery" = {
        ShowPercent = "YES";
      };
      "com.apple.menuextra.clock" = {
        IsAnalog = false;
        Show24Hour = true;
        ShowAMPM = false;
        ShowDate = 1;
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
        ShowSeconds = true;
      };
    };
  };

  home = {
    stateVersion = "24.05";
  };
}
