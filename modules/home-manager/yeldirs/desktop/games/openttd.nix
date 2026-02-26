{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.games.openttd;
in
{
  options = {
    yeldirs.desktop.games.openttd = {
      enable = lib.mkEnableOption "openttd";
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) (
    let
      openttdFiles = builtins.readDir ./openttd;
      configFiles = lib.filterAttrs (name: _: lib.hasSuffix ".cfg" name) openttdFiles;
      xdgConfigFiles = lib.mapAttrs' (
        name: _: lib.nameValuePair "openttd/${name}" { source = ./openttd/${name}; }
      ) configFiles;
    in
    {
      xdg.configFile = xdgConfigFiles;

      home = {
        packages = with pkgs; [
          openttd
          openttd-ttf
        ];

        persistence = {
          "/persist" = {
            directories = [
              ".local/share/openttd"
            ];
          };
        };
      };
    }
  );
}
