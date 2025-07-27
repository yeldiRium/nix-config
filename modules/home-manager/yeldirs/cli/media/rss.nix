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
      #   color background          ${c.on_background}         ${c.background}
      #   color listnormal          ${c.on_background}         ${c.background}
      #   color listfocus           ${c.on_primary_container}  ${c.primary_container}   bold
      #   color listnormal_unread   ${c.on_background}         ${c.background}          bold
      #   color listfocus_unread    ${c.on_primary_container}  ${c.primary_container}   bold
      #   color title               ${c.on_primary_container}  ${c.primary_container}   bold
      #   color info                ${c.on_primary_container}  ${c.primary_container}   bold
      #   color hint-key            ${c.on_primary_container}  ${c.primary_container}   bold
      #   color hint-keys-delimiter ${c.on_primary_container}  ${c.primary_container}
      #   color hint-separator      ${c.on_primary_container}  ${c.primary_container}   bold
      #   color hint-description    ${c.on_primary_container}  ${c.primary_container}
      #   color article             ${c.on_background}         ${c.background}
      '';

      urls = [
        {
          title = "yeldiRium";
          url = "https://yeldirium.de/atom.xml";
          tags = ["golang" "software development" "it"];
        }
        {
          title = "Bitfield Consulting";
          url = "https://bitfieldconsulting.com/posts?format=rss";
          tags = ["golang" "rust" "software development" "it"];
        }

        {
          title = "xkcd";
          url = "https://xkcd.com/atom.xml";
          tags = ["comic" "fun" "science"];
        }
        {
          title = "Poorly Drawn Lines";
          url = "https://poorlydrawnlines.com/feed/";
          tags = ["comic" "fun"];
        }
        {
          title = "Hi, I'm Liz";
          url = "https://lizclimo.tumblr.com/rss";
          tags = ["comic" "fun"];
        }
        {
          title = "Oglaf";
          url = "https://www.oglaf.com/feeds/rss/";
          tags = ["comic" "fun" "nsfw"];
        }
      ];
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
