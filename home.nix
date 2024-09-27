{ config, inputs, lib, pkgs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  programs = {
    git = {
      enable = true;
      userName = "Hannes Leutloff";
      userEmail = "hannes.leutloff@yeldirium.de";
    };
    ranger = {
      enable = true;
      settings = {
        show_hidden = true;
      };
    };
    ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
	  user = "yeldir";
	  identityFile = "~/.ssh/hleutloff";
	};
	"git.yeldirium.de" = {
	  user = "yeldir";
	  identityFile = "~/.ssh/hleutloff";
	  port = 30022;
	};
        "datengrab" = {
	  user = "yeldir";
	  identityFile = "~/.ssh/hleutloff";
	};
        "heck" = {
	  hostname = "yeldirium.de";
	  user = "yeldir";
	  identityFile = "~/.ssh/hleutloff";
	};
      };
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

    shellAliases = {
      nbuild = "sudo nixos-rebuild build --flake $FLAKE";
      nboot = "sudo nixos-rebuild boot --flake $FLAKE";
      nswitch = "sudo nixos-rebuild switch --flake $FLAKE";
    };

    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
	  ".config/google-chrome"
	  ".local/share/keyrings"
	  ".ssh"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "querbeet"
          "Videos"
        ];
        allowOther = true;
      };
    };
  };


  home.packages = [ ];
}
