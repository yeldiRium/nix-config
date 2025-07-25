{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.desktop.essentials.firefox;
in {
  options = {
    yeldirs.desktop.essentials.firefox = {
      enable = lib.mkEnableOption "firefox";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.firefox.override {
          nativeMessagingHosts = [
            pkgs.tridactyl-native
          ];
        };
      };
    };

    home = {
      persistence."/persist/${config.home.homeDirectory}" = {
        directories = [
          ".mozilla"
        ];
      };
    };
  };
}
