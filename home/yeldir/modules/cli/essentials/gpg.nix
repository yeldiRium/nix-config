{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.gpg;
in {
  options = {
    yeldirs.cli.essentials.gpg = {
      enable = lib.mkEnableOption "gpg";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      pinentryPackage =
        if config.gtk.enable
        then pkgs.pinentry-gnome3
        else pkgs.pinentry-tty;
    };

    home.packages = lib.optional config.gtk.enable pkgs.gcr;

    programs = {
      # Start gpg-agent if it's not running or tunneled in
      # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
      # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
      zsh.loginExtra = ''
        gpgconf --launch gpg-agent
      '';

      gpg = {
        enable = true;
        settings = {
          trust-model = "tofu+pgp";
        };
        publicKeys = [
          {
            source = ../../../pgp.asc;
            trust = 5;
          }
        ];
      };
    };

    home.persistence."/persist/${config.home.homeDirectory}" = {
      directories = [
        ".gnupg"
      ];
    };
  };
}
