{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../shared
    ./shared
    ./shared/linux

    ./optional/desktop/common
  ];

  wallpaper = pkgs.wallpapers.space-cloud-orange;

  yeldirs = {
    system = {
      hostName = "recreate";

      keyboardVariant = "";
    };

    cli = {
      development = {
        claude.enable = true;
        gh.enable = true;
        qmk.enable = true;
      };

      media = {
        music.enable = true;
        rss.enable = true;
      };

      office = {
        yt-dlp.enable = true;
      };

      ops = {
        docker.enable = true;
        fluxcd.enable = true;
        hetzner.enable = true;
        k9s.enable = true;
        kubectl.enable = true;
        networking.enable = true;
        nix.enable = true;
        tofu.enable = true;
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

      autostart = [
        {
          command = "gtk-launch org.telegram.desktop.desktop";
          workspace = "1";
          windowClass = "org.telegram.desktop";
        }
        {
          command = "gtk-launch zotero";
          workspace = "1";
          windowClass = "Zotero";
        }
        {
          command = "gtk-launch obsidian";
          workspace = "5";
          windowClass = "obsidian";
        }
        {
          command = "gtk-launch thunderbird";
          workspace = "7";
          windowClass = "thunderbird";
        }
        {
          command = "gtk-launch firefox";
          workspace = "3";
          windowClass = "firefox";
        }
      ];

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

      hyprland = {
        enable = true;
        enableAnimations = true;
        enableTransparency = false;
      };

      communication = {
        discord.enable = true;
        matrix.enable = true;
      };

      media = {
        clementine.enable = true;
        gimp.enable = true;
        spotify.enable = true;
        tagstudio.enable = true;
        vlc.enable = true;
      };

      games = {
        bottles.enable = true;
        minecraft.enable = true;
        nostromo.enable = true;
        openttd.enable = true;
        retroarch.enable = true;
        steam.enable = true;
      };

      office = {
        calibre.enable = true;
        citrix.enable = true;
        libreoffice.enable = true;
        nextcloud.enable = true;
        obsidian.enable = true;
        thunderbird = {
          enable = true;
          profile = "hannes.leutloff@yeldirium.de";
        };
      };
    };
  };

  home.persistence = {
    "/persist" = {
      directories = [
        ".local/share/Red Hook Studios" # Darkest Dungeon
      ];
    };
  };

  home = {
    stateVersion = "24.05";
  };
}
