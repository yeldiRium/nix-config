{
  config,
  lib,
  pkgs,
  ...
}:
let
  platform = config.yeldirs.system.platform;

  cfg = config.yeldirs.cli.essentials;
in
{
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
      packages =
        with pkgs;
        [
          # poweruser
          btop
          eza
          unstable.ijq
          jq
          pv
          silver-searcher
          unzip
          yq-go
          zip

          # nix utils
          nixfmt-rfc-style

          # encryption
          age
        ]
        ++ lib.optionals (platform == "linux") [
          dysk
        ]
        # custom scripts
        ++ [
          (y.shellScript ./scripts/diffex)
          (y.shellScript ./scripts/rand5)
        ];

      shellAliases = {
        ll = "eza --all --long --group-directories-first --binary --group --header --mounts --git";
        cat = "bat";
        hi = "ag --passthrough";
        ijq = "ijq -hide-input-pane";
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
