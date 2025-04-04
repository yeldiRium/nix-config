{pkgs, ...}: {
  imports = [
    ../shared
    ./shared
    ./shared/linux

    ./optional/desktop/development
    ./optional/desktop/hyprland

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
        discord.enable = true;
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
          command = "gtk-launch obsidian";
          workspace = "5";
          selector = "class:obsidian";
        }
        {
          command = "gtk-launch thunderbird";
          workspace = "7";
          selector = "class:thunderbird";
        }
        {
          command = "gtk-launch google-chrome";
        }
      ];
    };
  };

  monitors = [
    {
      name = "desc:Dell Inc. DELL P2717H 4P9HC7A6AHES";
      width = 1920;
      height = 1080;
      position = "1080x200";
      primary = true;
      workspace = "2";
    }
    {
      name = "desc:Dell Inc. DELL P2719H 3R855R2";
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
