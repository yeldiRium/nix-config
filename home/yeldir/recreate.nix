{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../shared
    ./shared
    ./shared/linux

    ./optional/desktop/development
    ./optional/desktop/hyprland

    ./optional/desktop/communication
    ./optional/desktop/games
    ./optional/desktop/media
    ./optional/desktop/office
    ./optional/desktop/chrome.nix
    ./optional/desktop/spotify.nix
  ];

  wallpaper = pkgs.wallpapers.space-cloud-orange;

  yeldirs = {
    system = {
      hostName = "recreate";

      keyboardVariant = "";
    };

    cli = {
      essentials = {
        neovim = {
          supportedLanguages = [
            "go"
            "javascript"
            "poefilter"
            "typescript"
          ];
        };
      };

      development = {
        qmk.enable = true;
      };

      office = {
        yt-dlp.enable = true;
      };

      ops = {
        colima.enable = false;
        helm.enable = true;
        k9s.enable = true;
        kubectl.enable = true;
        lazydocker.enable = true;
      };
    };

    desktop = {
      communication = {
        matrix.enable = true;
      };

      games = {
        nds.enable = true;
        wow.enable = true;
      };

      media = {
        clementine.enable = true;
        gimp.enable = true;
      };
    };

    # Deprecated non-module options.
    hyprland = {
      enableAnimations = true;
      enableTransparency = true;
    };
  };

  monitors = [
    {
      name = "DP-3";
      width = 1920;
      height = 1080;
      position = "1080x200";
      primary = true;
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      position = "0x0";
      transform = 3;
      workspace = "1";
    }
  ];
  autostart = [
    {
      command = "${lib.getExe pkgs.telegram-desktop}";
      workspace = "1";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.zotero}";
      workspace = "1";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.google-chrome}";
      workspace = "2";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.obsidian}";
      workspace = "5";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.thunderbird}";
      workspace = "7";
      monitor = "DP-3";
    }
  ];

  home = {
    stateVersion = "24.05";
  };
}
