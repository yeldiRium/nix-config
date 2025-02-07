{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../shared

    ./optional/cli
    ./optional/desktop/development
    ./optional/desktop/hyprland
    ./optional/keyring

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
      platform = "linux";

      keyboardLayout = "de";
      keyboardVariant = "";
      sops = {
        enable = true;
        sopsFile = ./secrets.yaml;
        keyFile = "/persist/sops/age/keys.txt";
      };
      mounts = {
        datengrab.enable = true;
      };
    };

    cli = {
      essentials = {
        zsh = {
          enable = true;
          enableSecretEnv = true;
        };

        bat.enable = true;
        git.enable = true;
        gpg = {
          enable = true;
          trustedPgpKeys = [
            ./pgp.asc
          ];
        };
        hstr.enable = true;
        ranger = {
          enable = true;
          enableGui = true;
        };
        ssh.enable = true;
        thefuck.enable = true;

        neovim = {
          enable = true;

          supportedLanguages = [
            "bash"
            "docker"
            "go"
            "javascript"
            "json"
            "ledger"
            "lua"
            "markdown"
            "nix"
            "poefilter"
            "typescript"
            "yaml"
          ];

          layout = {
            indentation-guides.enable = true;
          };

          copilot.enable = true;
          debugging.enable = true;
          early-retirement.enable = true;
          firenvim.enable = true;
          fold-cycle.enable = true;
          git.enable = true;
          harpoon2.enable = true;
          lsp.enable = true;
          nrvimr.enable = true;
          obsidian.enable = true;
          telescope.enable = true;
          testing.enable = true;
          treesitter.enable = true;
          undotree.enable = true;
        };
      };

      development = {
        qmk.enable = true;
      };

      office = {
        taskwarrior.enable = true;
        yt-dlp.enable = true;
      };

      ops = {
        colima.enable = false;
        k9s.enable = true;
        kubectl.enable = true;
        lazydocker.enable = true;
        minikube.enable = true;
      };
    };

    desktop = {
      communication = {
        matrix.enable = true;
      };
      essentials = {
        kitty.enable = true;
      };
      games = {
        nds.enable = true;
        wow.enable = true;
      };
      media = {
        clementine.enable = true;
        gimp.enable = true;
      };
      office = {
        zotero.enable = true;
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
}
