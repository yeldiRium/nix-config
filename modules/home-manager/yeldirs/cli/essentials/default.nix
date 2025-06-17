{
  config,
  lib,
  pkgs,
  ...
}: let
  shellScript = import ../../../../../lib/shellScript.nix pkgs;
  platform = config.yeldirs.system.platform;

  cfg = config.yeldirs.cli.essentials;
in {
  imports = [
    ./neovim
    ./tmux

    ./atuin.nix
    ./devbox.nix
    ./git.nix
    ./gpg.nix
    ./isd.nix
    ./ssh.nix
    ./yazi.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  options = {
    yeldirs.cli.essentials.enable = lib.mkEnableOption "cli essentials";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          # poweruser
          btop
          ijq
          jq
          pv
          silver-searcher
          unzip
          yq
          zip

          # nix utils
          alejandra
        ]
        ++ lib.optionals (platform == "linux") [
          dysk
        ]
        # custom scripts
        ++ [
          (shellScript ./scripts/diffex)
          (shellScript ./scripts/rand5)
        ];

      shellAliases = {
        ll = "ls -al";
        hi = "ag --passthrough";
      };
    };

    programs = {
      bat = {
        enable = true;
        config.theme = "base16";
      };
      fzf = {
        enable = true;
        defaultOptions = [
          "--tmux"
        ];
      };
      thefuck = {
        enable = true;
        enableZshIntegration = config.programs.zsh.enable;
      };
    };
  };
}
