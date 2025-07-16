{
  lib,
  config,
  ...
}: let
  cfg = config.yeldirs.cli.media.rss;
in {
  options = {
    yeldirs.cli.media.rss.enable = lib.mkEnableOption "rss";
  };

  config = lib.mkIf cfg.enable {
    programs.newsboat = {
      enable = true;
      autoReload = true;

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
          tags = ["comics" "fun" "science"];
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
  };
}
