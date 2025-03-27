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

          # Set viins as default keymap. The home manager option zsh.defaultKeyMap
          # seems to be overwritten by oh-my-zsh, which is why this has to be
          # set manually.
          bindkey -v
        '';
        oh-my-zsh = {
          enable = true;
          extraConfig = ''
            ZSHZ_DATA="$HOME/.local/share/zsh/.z"
          '';
          plugins = [
            "wd"
            "z"
          ];
        };

        history = {
          path = "$HOME/.local/share/zsh/.zsh_history";
        };

        syntaxHighlighting = {
          enable = true;
          highlighters = [
            "brackets"
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
          ];
          directories = [
            ".local/share/zsh"
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
