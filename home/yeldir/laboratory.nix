{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence

    ./global

    ./features/cli
    ./features/desktop/hyprland
    ./features/development
    ./features/pass
  ];

  home = {
    username = lib.mkDefault "yeldir";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.05";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      FLAKE = "$HOME/querbeet/workspace/nix-config";

      # Set default applications. Should also/alternatively be done using mime apps.
      EDITOR = "nvim";
      BROWSER = "google-chrome";
      TERMINAL = "kitty";
    };

    shellAliases = {
      # TODO: replace #default with hostname when restructuring config
      nbuild = "sudo nixos-rebuild build --flake $FLAKE#laboratory";
      nboot = "sudo nixos-rebuild boot --flake $FLAKE#laboratory";
      nswitch = "sudo nixos-rebuild switch --flake $FLAKE#laboratory";
      nrepl = "sudo nixos-rebuild repl --flake $FLAKE#laboratory";
    };

    packages = with pkgs; [
      alejandra
      pavucontrol
    ];

    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".config/google-chrome"
          ".ssh"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "querbeet"
          "Videos"
        ];
        files = [
          ".warprc"
        ];
      };
    };
  };

  services = {
    mako = {
      enable = true;
    };
  };

  programs = {
    swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
    };
    tofi = {
      enable = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "wd"
        ];
      };
    };
  };
  # It seems waybar sometimes doesn't want to start. Give it a few trys.
  systemd.user.services.waybar = {
    Unit.StartLimitBurst = 30;
  };

  # monitors = [
  #   {
  #     name = "LVDS-1";
  #     width = 1600;
  #     height = 900;
  #     workspace = "2";
  #   }
  #   {
  #     name = "HDMI-A-1";
  #     width = 1920;
  #     height = 1080;
  #     workspace = "1";
  #     primary = true;
  #   }
  # ];
}
