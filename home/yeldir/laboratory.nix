{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./global

    ./features/desktop/hyprland
    ./features/development
    ./features/pass
  ];

  home = {
    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          # TODO: make chrome module
          ".config/google-chrome"
        ];
      };
    };
  };

  programs = {
    # TODO: replace tofi with wofi
    tofi = {
      enable = true;
    };
  };

  hostName = "laboratory";

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
