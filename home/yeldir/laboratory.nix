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

  hostName = "laboratory";

  wallpaper = pkgs.wallpapers.cyberpunk-tree-landscape;

  yeldirs = {
    cli = {
      taskwarrior.enable = true;

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

      zsh = {
        enable = true;
        enableSecretEnv = true;
      };
    };
    desktop = {
      common = {
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
}
