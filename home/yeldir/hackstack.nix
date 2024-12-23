{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./global
    ./modules

    ./optional/desktop/development
    ./optional/desktop/hyprland
    ./optional/keyring

    ./optional/desktop/communication/telegram.nix
    ./optional/desktop/media
    ./optional/desktop/office
    ./optional/desktop/chrome.nix
    ./optional/desktop/spotify.nix
  ];

  hostName = "hackstack";

  wallpaper = pkgs.wallpapers.cyberpunk-tree-landscape;

  yeldirs = {
    cli = {
      essentials = {
        zsh = {
          enable = true;
          enableSecretEnv = true;
        };

        bat.enable = true;
        git.enable = true;
        gpg.enable = true;
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
        taskwarrior.enable = false;
      };
    };

    desktop = {
      communication = {
        matrix.enable = true;
      };
      essentials = {
        kitty.enable = true;
      };
    };

    system = {
      keyboardLayout = "de";
      keyboardVariant = "neo";
      mounts = {
        datengrab.enable = true;
      };
    };

    # Deprecated non-module options:
    hyprland = {
      enableAnimations = false;
      enableTransparency = false;
    };
    sops = {
      keyFile = "/persist/sops/age/keys.txt";
    };
  };

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      position = "1920x800";
      primary = true;
    }
  ];
  autostart = [
    {
      command = "${lib.getExe pkgs.telegram-desktop}";
      workspace = "1";
      monitor = null;
    }
    {
      command = "${lib.getExe pkgs.element-desktop}";
      workspace = "1";
      monitor = null;
    }
    {
      command = "${lib.getExe pkgs.google-chrome}";
      workspace = "2";
      monitor = null;
    }
    {
      command = "${lib.getExe pkgs.obsidian}";
      workspace = "5";
      monitor = null;
    }
    {
      command = "${lib.getExe pkgs.thunderbird}";
      workspace = "7";
      monitor = null;
    }
  ];
}
