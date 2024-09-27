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

    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
	  ".config/google-chrome"
	  ".local/share/keyrings"
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
