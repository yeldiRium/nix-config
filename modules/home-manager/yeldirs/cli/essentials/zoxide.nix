{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli) essentials;
in
{
  config = lib.mkIf essentials.enable {
    programs = {
      zoxide = {
        enable = true;
      };
    };

    home = {
      # zoxide dependencies
      packages = with pkgs; [
        fzf
      ];

      persistence = {
        "/persist" = {
          directories = [
            ".local/share/zoxide"
          ];
        };
      };
    };
  };
}
