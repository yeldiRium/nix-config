{
  config,
  lib,
  ...
}: let
  essentials = config.yeldirs.cli.essentials;
in {
  config = lib.mkIf essentials.enable {
    programs = {
      atuin = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          filter_mode = "host";
          cwd_filter = [
            "/temp$"
            "/temp/"
          ];
          style = "full";
          inline_height = 0;
        };
      };
    };

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".local/share/atuin"
        ];
      };
    };
  };
}
