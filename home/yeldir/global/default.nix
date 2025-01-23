{
  config,
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}: let
  platform = config.yeldirs.system.platform;
in {
  imports =
    [
      inputs.impermanence.nixosModules.home-manager.impermanence

      ./disable-impermanence.nix
      ./scripts.nix
      ./sops.nix
      ../optional/cli
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  options = {
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "laboratory";
      description = "The hostname of the system.";
    };
  };

  config = {
    assertions = [
      {
        assertion = config.hostName != "";
        message = "HostName must be set!";
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
        if platform == "linux"
        then {
          nbuild = "sudo nixos-rebuild build --flake $FLAKE#${config.hostName}";
          nboot = "sudo nixos-rebuild boot --flake $FLAKE#${config.hostName}";
          nswitch = "sudo nixos-rebuild switch --flake $FLAKE#${config.hostName}";
          nrepl = "sudo nixos-rebuild repl --flake $FLAKE#${config.hostName}";
          nrollback = "sudo nixos-rebuild switch --flake $FLAKE#${config.hostName} --rollback";
        }
        else {
          nbuild = "sudo nix run nix-darwin -- build --flake $FLAKE#${config.hostName}";
          nboot = "sudo nix run nix-darwin -- boot --flake $FLAKE#${config.hostName}";
          nswitch = "sudo nix run nix-darwin -- switch --flake $FLAKE#${config.hostName}";
          nrollback = "sudo nix run nix-darwin switch --flake $FLAKE#${config.hostName} --rollback";
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

    colorscheme.mode = lib.mkOverride 1499 "dark";
    home.file = {
      ".colorscheme.json".text = builtins.toJSON config.colorscheme;
    };
  };
}
