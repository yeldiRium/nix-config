{lib, pkgs, ...}: {
  imports = [
    ../shared
    ./shared
    ./shared/linux

    ./optional/desktop/development
    ./optional/desktop/hyprland

    ./optional/desktop/games
    ./optional/desktop/media
    ./optional/desktop/office
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
            "rust"
            "typescript"
          ];
        };
      };

      development = {
        gh.enable = true;
        qmk.enable = true;
      };

      media = {
        rss.enable = true;
      };

      office = {
        yt-dlp.enable = true;
      };

      ops = {
        lazydocker.enable = true;
        nix.enable = true;
      };
    };

    desktop = {
      essentials = {
        firefox = {
          enable = true;
          default = true;
        };
        chrome = {
          default = lib.mkForce false;
        };
      };

      communication = {
        discord.enable = true;
        matrix.enable = true;
      };

      media = {
        clementine.enable = true;
        gimp.enable = true;
      };

      games = {
        openttd.enable = true;
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
          command = "gtk-launch firefox";
          workspace = "3";
          selector = "class:firefox";
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
      workspace = "3";
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
