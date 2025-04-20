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
