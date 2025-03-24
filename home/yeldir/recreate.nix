{pkgs, ...}: {
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

      autostart = [
        {
          command = "gtk-launch org.telegram.desktop.desktop";
          workspace = "1";
          selector = "class:org.telegram.desktop";
        }
        {
          command = "gtk-launch zotero";
          workspace = "1";
          selector = "class:Zotero";
        }
        {
          command = "gtk-launch google-chrome";
        }
        {
          command = "gtk-launch obsidian";
          workspace = "5";
          selector = "class:obsidian";
        }
        {
          command = "gtk-launch thunderbird";
          workspace = "7";
          selector = "class:thunderbird";
        }
      ];
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

  home = {
    stateVersion = "24.05";
  };
}
