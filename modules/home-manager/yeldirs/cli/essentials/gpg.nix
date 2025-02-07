{
  pkgs,
  config,
  lib,
  ...
}: let
  platform = config.yeldirs.system.platform;
  cfg = config.yeldirs.cli.essentials.gpg;
in {
  options = {
    yeldirs.cli.essentials.gpg = {
      enable = lib.mkEnableOption "gpg";

      trustedPgpKeys = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
        description = "a list of pgp keys that are imported with ultimat trust";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      pinentryPackage =
        if platform == "darwin"
        then pkgs.pinentry_mac
        else if config.gtk.enable
        then pkgs.pinentry-gnome3
        else pkgs.pinentry-tty;
      extraConfig = ''
        allow-loopback-pinentry
      '';
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
          pinentry-mode = "loopback";
        };
        publicKeys =
          map (
            trustedPgpPath: {
              source = trustedPgpPath;
              trust = 5;
            }
          )
          cfg.trustedPgpKeys;
      };
    };

    home.persistence."/persist/${config.home.homeDirectory}" = {
      directories = [
        ".gnupg"
      ];
    };
  };
}
