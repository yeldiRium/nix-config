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

      # Makes firefox use wayland directly, improves performance.
      MOZ_ENABLE_WAYLAND = 1;
      # Makes QT applications use wayland.
      QT_QPA_PLATFORM = "wayland";
      # Idk what this does yet.
      LIBSEAT_BACKEND = "logind";
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
      libnotify
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

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };

    plugins = [
      pkgs.hyprlandPlugins.hyprbars
    ];

    settings = {
      input = {
        kb_layout = "de";
        kb_variant = "neo";
        resolve_binds_by_sym = true;
      };
      device =
        map (keyboard: {
          name = "${keyboard}";
          kb_layout = "de";
          kb_variant = "";
        }) [
          "zsa-technology-labs-inc-ergodox-ez"
          "zsa-technology-labs-inc-ergodox-ez-keyboard"
          "zsa-technology-labs-inc-ergodox-ez-system-control"
          "zsa-technology-labs-inc-ergodox-ez-consumer-control"
        ];

      exec = [
        "${pkgs.waybar}/bin/waybar"
        #"hyperctl setcursor ${config.gtk.cursorTheme.name} ${toString config.gtk.cursorTheme.size}"
      ];

      "$mod" = "SUPER";
      "$terminal" = "kitty";

      # TODO: add swaybg or similar for wallpaper

      # TODO: configure monitors

      # TODO: configure hyprland appearance

      # TODO: add bindings for
      # - pactl (volume)
      # - playerctl (track)
      # - screenshots
      # - brightness (lightd)
      bind =
        [
          "$mod SHIFT, Q, exit" # Exits out of hyprland
          "$mod, Q, killactive" # Closes the focused window
          "$mod, Return, exec, $terminal" # Launches a terminal
        ]
        ++ (
          # Launch programs with tofi
          let
            tofi = lib.getExe config.programs.tofi.package;
          in
            lib.optionals config.programs.tofi.enable [
              "$mod, A, exec, ${tofi}-drun | xargs hyprctl dispatch exec --" # Opens app launcher
            ]
        )
        ++ (
          # Lock screen with swaylock
          let
            swaylock = lib.getExe config.programs.swaylock.package;
          in
            lib.optionals config.programs.swaylock.enable [
              "$mod, L, exec, ${swaylock} -S --grace 2 --grace-no-mouse"
              "$mod, XF86ScreenSaver, exec, ${swaylock} -S --grace 2 --grace-no-mouse"
            ]
        )
        ++ [
          # navigate around windows
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
        ]
        ++ [
          # adjust layout
          "$mod, Space, togglefloating"
          "$mod, G, togglegroup"
          "$mod, F, fullscreen"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
  };

  xdg.mimeApps.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config.hyprland = {
      default = ["wlr" "gtk"];
    };
  };

  gtk = {
    enable = true;
  };

  services = {
    mako = {
      enable = true;
    };
    network-manager-applet = {
      enable = true;
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "Hannes Leutloff";
      userEmail = "hannes.leutloff@yeldirium.de";

      ignores = [
        ".vscode"
      ];
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