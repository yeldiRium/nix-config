{
  config,
  lib,
  pkgs,
  ...
}:
let
  essentials = config.yeldirs.cli.essentials;
  cfg = config.yeldirs.cli.essentials.zsh;
in
{
  options = {
    yeldirs.cli.essentials.zsh = {
      enableSecretEnv = lib.mkOption {
        type = lib.types.bool;
        description = "Requires sops to be enabled. Mounts ~/.secretenv from the sops secrets.";
        default = false;
      };
    };
  };

  config = lib.mkIf essentials.enable {
    home.file.".p10k.zsh".text = builtins.readFile ./.p10k.zsh;

    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        initContent = ''
          source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          source ~/.p10k.zsh;

          # Set viins as default keymap. The home manager option zsh.defaultKeyMap
          # seems to be overwritten by oh-my-zsh, which is why this has to be
          # set manually.
          bindkey -v

          zstyle ':completion:*:descriptions' format '[%d]'
          zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
        '';
        oh-my-zsh = {
          enable = true;
        };
        plugins = [
          {
            name = "fzf-tab";
            src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
          }
        ];

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
        zsh-fzf-tab
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
