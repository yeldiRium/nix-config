{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.ops.colima;
in {
  options = {
    yeldirs.cli.ops.colima = {
      enable = lib.mkEnableOption "colima";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      colima
      docker-client

      # Only install the pkill binary from toybox
      (pkgs.linkFarm "pkill" [
        {
          name = "bin/pkill";
          path = pkgs.toybox;
        }
      ])
    ];

    programs = {
      zsh.initContent = lib.mkIf config.programs.zsh.enable ''
        eval "$(${lib.getExe pkgs.colima} completion zsh)"
      '';
    };

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".config/colima"
        ];
      };
    };
  };
}
