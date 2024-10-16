{
  programs.thunderbird = {
    enable = true;
    profiles = {
      "hannes.leutloff@yeldirium.de" = {
        isDefault = true;
      };
    };
  };

  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".thunderbird"
    ];
  };
}
