{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.zsh;
in {
  options = {
    yeldirs.cli.essentials.zsh = {
      enable = lib.mkEnableOption "zsh";
      enableSecretEnv = lib.mkOption {
        type = lib.types.bool;
        description = "Requires sops to be enabled. Mounts ~/.secretenv from the sops secrets.";
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".p10k.zsh".text = builtins.readFile ./.p10k.zsh;

    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        initExtra = ''
          source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          source ~/.p10k.zsh;
        '';
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "wd"
          ];
        };

        # Source secrets that are mounted via sops
        envExtra = lib.mkIf cfg.enableSecretEnv "source ~/.secretenv";
      };
    };

    home = {
      packages = with pkgs; [
        zsh-powerlevel10k
      ];

      persistence = {
        "/persist/${config.home.homeDirectory}" = {
          files = [
            ".warprc"
            ".zsh_history"
          ];
        };
      };
    };

    sops = lib.mkIf cfg.enableSecretEnv {
      secrets.secretenv = {
        path = "${config.home.homeDirectory}/.secretenv";
      };
    };
  };
}
