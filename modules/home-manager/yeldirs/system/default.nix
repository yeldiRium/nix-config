{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.system;
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence

    ./mounts

    ./keyring.nix
    ./disable-impermanence.nix
    ./sops.nix
  ];

  options = {
    yeldirs.system.username = lib.mkOption {
      type = lib.types.str;
      example = "yeldir";
    };

    yeldirs.system.hostName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "laboratory";
      description = "The hostname of the system.";
    };
    yeldirs.system.platform = lib.mkOption {
      type = lib.types.enum [
        "linux"
        "darwin"
      ];
      description = "The system platform";
    };

    yeldirs.system.keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "de";
      description = "The keyboard layout to use.";
    };
    yeldirs.system.keyboardVariant = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The keyboard variant to use.";
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.username != "";
        message = "Username must be set!";
      }
      {
        assertion = cfg.hostName != "";
        message = "HostName must be set!";
      }
      {
        assertion = cfg.platform != "";
        message = "Platform must be set to either 'linux' or 'darwin'.";
      }
    ];

    nix = {
      package = lib.mkDefault pkgs.nix;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        warn-dirty = false;
      };
    };

    systemd.user.startServices = "sd-switch";

    home = {
      username = lib.mkDefault cfg.username;
      homeDirectory = lib.mkDefault "/home/${cfg.username}";
      sessionPath = [
        "$HOME/.local/bin"
      ];
      sessionVariables = {
        FLAKE = "$HOME/querbeet/workspace/nix-config";
      };

      packages = with pkgs; [
        nix-diff
        nix-output-monitor
      ];

      shellAliases = {
        ndiff = "nbuild && nix-diff /nix/var/nix/profiles/system result";
      }
      // (
        if cfg.platform == "linux" then
          {
            nbuild = "sudo echo && sudo nixos-rebuild build --flake $FLAKE#${cfg.hostName} |& nom";
            nboot = "sudo echo && sudo nixos-rebuild boot --flake $FLAKE#${cfg.hostName} |& nom";
            nswitch = "sudo echo && sudo nixos-rebuild switch --flake $FLAKE#${cfg.hostName} |& nom";
            nrepl = "sudo echo && sudo nixos-rebuild repl --flake $FLAKE#${cfg.hostName} |& nom";
            nrollback = "sudo echo && sudo nixos-rebuild switch --flake $FLAKE#${cfg.hostName} --rollback |& nom";
          }
        else
          {
            nbuild = "sudo nix run nix-darwin -- build --flake $FLAKE#${cfg.hostName}";
            nboot = "sudo nix run nix-darwin -- boot --flake $FLAKE#${cfg.hostName}";
            nswitch = "sudo nix run nix-darwin -- switch --flake $FLAKE#${cfg.hostName}";
            nrollback = "sudo nix run nix-darwin switch --flake $FLAKE#${cfg.hostName} --rollback";
          }
      );

      file = {
        ".colorscheme.json".text = builtins.toJSON config.colorscheme;
      };

      persistence = {
        "/persist/${config.home.homeDirectory}" = {
          directories = [
            "Documents"
            "Downloads"
            "Music"
            "Pictures"
            "querbeet"
            "Videos"
            ".config/pulse"
            ".local/bin"
            ".local/share/nix" # trusted settings and repl history
          ];
          allowOther = true;
        };
      };
    };

    xdg.enable = true;

    colorscheme.mode = lib.mkOverride 1499 "dark";
  };
}
