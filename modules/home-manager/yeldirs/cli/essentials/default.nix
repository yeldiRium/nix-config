{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials;
  yeldirsCfg = config.yeldirs;
in {
  imports = [
    ./neovim

    ./git.nix
    ./gpg.nix
    ./isd.nix
    ./ranger.nix
    ./ssh.nix
    ./zsh.nix
  ];

  options = {
    yeldirs.cli.essentials.enable = lib.mkEnableOption "cli essentials";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # poweruser
        jq
        silver-searcher
        btop
        zip
        unzip

        # nix utils
        alejandra

        # development
        devbox
      ];

      shellAliases = {
        ll = "ls -al";
      };
    };

    programs = {
      bat = {
        enable = true;
        config.theme = "base16";
      };
      hstr = {
        enable = true;

        enableZshIntegration = yeldirsCfg.cli.essentials.zsh.enable;
      };
      thefuck = {
        enable = true;
        enableZshIntegration = yeldirsCfg.cli.essentials.zsh.enable;
      };
    };
  };
}
