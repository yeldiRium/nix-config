{
  lib,
  config,
  ...
}: let
  cfg = config.yeldirs.cli.media.rss;
  c = config.colorscheme.colors // config.colorscheme.harmonized;
in {
  options = {
    yeldirs.cli.media.rss.enable = lib.mkEnableOption "rss";
  };

  config = lib.mkIf cfg.enable {
    programs.newsboat = {
      enable = true;
      autoReload = true;

      extraConfig = ''
        datetime-format "%F"
        # color background          ${c.on_background}         ${c.background}
        # color listnormal          ${c.on_background}         ${c.background}
        # color listfocus           ${c.on_primary_container}  ${c.primary_container}   bold
        # color listnormal_unread   ${c.on_background}         ${c.background}          bold
        # color listfocus_unread    ${c.on_primary_container}  ${c.primary_container}   bold
        # color title               ${c.on_primary_container}  ${c.primary_container}   bold
        # color info                ${c.on_primary_container}  ${c.primary_container}   bold
        # color hint-key            ${c.on_primary_container}  ${c.primary_container}   bold
        # color hint-keys-delimiter ${c.on_primary_container}  ${c.primary_container}
        # color hint-separator      ${c.on_primary_container}  ${c.primary_container}   bold
        # color hint-description    ${c.on_primary_container}  ${c.primary_container}
        # color article             ${c.on_background}         ${c.background}
      '';
    };

    sops.secrets.rssUrls = {
      path = "${config.home.homeDirectory}/.config/newsboat/urls";
    };

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".local/share/newsboat"
        ];
      };
    };
  };
}
