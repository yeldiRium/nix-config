{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.system.keyring;
in {
  options = {
    yeldirs.system.keyring.enable = lib.mkEnableOption "keyring";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome-keyring
      seahorse
    ];
    services.gnome-keyring.enable = true;

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".local/share/keyrings"
        ];
      };
    };
  };
}
