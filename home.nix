{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
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
      EDITOR = "nvim";
      BROWSER = "google-chrome";
      TERMINAL = "kitty";
    };

    shellAliases = { # TODO: replace #default with hostname when restructuring config
      nbuild = "sudo nixos-rebuild build --flake $FLAKE#default"; 
      nboot = "sudo nixos-rebuild boot --flake $FLAKE#default";
      nswitch = "sudo nixos-rebuild switch --flake $FLAKE#default";
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
	files = [
	  ".warprc"
	];
        allowOther = true;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
	"systemctl --user start hyprland-session.targer"
      ];
    };

    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];

    settings = {
      input = {
        kb_layout = "de";
	kb_variant = "neo";
      };

      "$mod" = "SUPER";
      "$terminal" = "kitty";

      bind = [
        "$mod, A, exec, tofi-drun | xargs hyprctl dispatch exec --" # Opens app launcher
	"$mod, Q, killactive" # Closes the focussed window
	"$mod, Return, exec, $terminal"

	# navigate around windows
	"$mod, left, movefocus, l"
	"$mod, right, movefocus, r"
	"$mod, up, movefocus, u"
	"$mod, down, movefocus, d"
	"$mod SHIFT, left, movewindow, l"
	"$mod SHIFT, right, movewindow, r"
	"$mod SHIFT, up, movewindow, u"
	"$mod SHIFT, down, movewindow, d"

	# adjust layout
	"$mod, Space, togglefloating"
	"$mod, G, togglegroup"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
    };
  };

  xdg.portal = {
    extraPortals = [pkgs.xdg-desktop-portal-wlr];
    config.hyprland = {
      default = ["wlr" "gtk"];
    };
  };

  services = {
    mako = {
      enable = true;
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "Hannes Leutloff";
      userEmail = "hannes.leutloff@yeldirium.de";
    };
    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
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
    tofi = {
      enable = true;
    };
    waybar = {
      enable = true;
      systemd.enable = true;
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

  home.packages = [];
}
