{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./global
    ./modules/cli/neovim
    ./modules/system/mounts

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

  hostName = "recreate";

  wallpaper = pkgs.wallpapers.space-cloud-orange;

  yeldirs = {
    cli = {
      neovim = {
        enable = true;

        supportedLanguages = [
          "docker"
          "go"
          "javascript"
          "json"
          "ledger"
          "lua"
          "markdown"
          "nix"
          "typescript"
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
        enableSecretEnv = true;
      };
    };
    hyprland = {
      enableAnimations = true;
      enableTransparency = true;
    };
    sops = {
      keyFile = "/persist/sops/age/keys.txt";
    };
    system = {
      mounts = {
        datengrab.enable = true;
      };
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
      command = "${lib.getExe pkgs.vesktop}";
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
      command = "${lib.getExe pkgs.spotify}";
      workspace = "6";
      monitor = "DP-3";
    }
    {
      command = "${lib.getExe pkgs.thunderbird}";
      workspace = "7";
      monitor = "DP-3";
    }
  ];
}
