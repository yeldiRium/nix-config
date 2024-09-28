{
  programs = {
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
  };
}
