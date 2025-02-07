{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../shared
    ./shared

    ./optional/desktop/development
    ./optional/desktop/hyprland
    ./optional/keyring

    ./optional/desktop/communication/telegram.nix
    ./optional/desktop/media
    ./optional/desktop/office
    ./optional/desktop/chrome.nix
    ./optional/desktop/spotify.nix
  ];

  wallpaper = pkgs.wallpapers.cyberpunk-tree-landscape;

  yeldirs = {
    system = {
      hostName = "laboratory";
      platform = "linux";

      keyboardLayout = "de";
      keyboardVariant = "neo";
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

        git.enable = true;
        gpg = {
          enable = true;
          trustedPgpKeys = [
            ./pgp.asc
          ];
        };
        ranger = {
          enable = true;
          enableGui = true;
        };
        ssh.enable = true;

        neovim = {
          enable = true;

          supportedLanguages = [
            "bash"
            "json"
            "ledger"
            "lua"
            "markdown"
            "nix"
            "yaml"
          ];

          copilot.enable = true;
          debugging.enable = true;
          git.enable = true;
          harpoon2.enable = true;
          lsp.enable = true;
          nrvimr.enable = true;
          telescope.enable = true;
          testing.enable = true;
          treesitter.enable = true;
          undotree.enable = true;
        };
      };

      office = {
        taskwarrior.enable = true;
      };
    };

    desktop = {
      essentials = {
        kitty.enable = true;
      };
    };

    # Deprecated non-module options:
    hyprland = {
      enableAnimations = false;
      enableTransparency = false;
    };
  };

  monitors = [
    {
      name = "LVDS-1";
      width = 1600;
      height = 900;
      workspace = "9";
      position = "1920x800";
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      primary = true;
      position = "0x0";
    }
  ];
  autostart = [
    {
      command = "${lib.getExe pkgs.telegram-desktop}";
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
