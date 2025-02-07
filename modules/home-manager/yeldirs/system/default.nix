{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.system;
in {
  imports =
    [
      inputs.impermanence.nixosModules.home-manager.impermanence

      ./mounts

      ./disable-impermanence.nix
      ./sops.nix
    ];

  options = {
    yeldirs.system.hostName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "laboratory";
      description = "The hostname of the system.";
    };
    yeldirs.system.platform = lib.mkOption {
      type = lib.types.enum ["linux" "darwin"];
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
        ];
        warn-dirty = false;
      };
    };

    systemd.user.startServices = "sd-switch";

    home = {
      username = lib.mkDefault "yeldir";
      homeDirectory = lib.mkDefault "/home/${config.home.username}";
      stateVersion = lib.mkDefault "24.05";
      sessionPath = [
        "$HOME/.local/bin"
      ];
      sessionVariables = {
        FLAKE = "$HOME/querbeet/workspace/nix-config";
      };

      shellAliases =
        {
          ndiff = "nbuild && nix-shell -p nix-diff --run \"nix-diff result /nix/var/nix/profiles/system\"";
        }
        // (
          if cfg.platform == "linux"
          then {
            nbuild = "sudo nixos-rebuild build --flake $FLAKE#${cfg.hostName}";
            nboot = "sudo nixos-rebuild boot --flake $FLAKE#${cfg.hostName}";
            nswitch = "sudo nixos-rebuild switch --flake $FLAKE#${cfg.hostName}";
            nrepl = "sudo nixos-rebuild repl --flake $FLAKE#${cfg.hostName}";
            nrollback = "sudo nixos-rebuild switch --flake $FLAKE#${cfg.hostName} --rollback";
          }
          else {
            nbuild = "nix run nix-darwin -- build --flake $FLAKE#${cfg.hostName}";
            nboot = "nix run nix-darwin -- boot --flake $FLAKE#${cfg.hostName}";
            nswitch = "nix run nix-darwin -- switch --flake $FLAKE#${cfg.hostName}";
            nrollback = "nix run nix-darwin switch --flake $FLAKE#${cfg.hostName} --rollback";
          }
        );

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

    colorscheme.mode = lib.mkOverride 1499 "dark";
    home.file = {
      ".colorscheme.json".text = builtins.toJSON config.colorscheme;
    };
  };
}
