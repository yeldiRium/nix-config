{
  config,
  lib,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.office.thunderbird;
in
{
  options = {
    yeldirs.desktop.office.thunderbird = {
      enable = lib.mkEnableOption "thunderbird";
      profile = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    programs.thunderbird = {
      enable = true;
      profiles = {
        "hannes.leutloff@yeldirium.de" = {
          isDefault = true;
        };
      };
      settings = {
        "mail.uidensity" = 0;
        "mail.uifontsize" = 12;
        "calendar.week.start" = 1;

        # Suppress donation popup.
        "app.donation.eoy.version.viewed" = 100;
      };
    };

    home.persistence."/persist" = {
      directories = [
        ".thunderbird"
      ];
    };
  };
}
