{
  config,
  lib,
  pkgs,
  ...
}: let
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
          dysk
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
        # custom scripts
        ++ (let
          script = name:
            pkgs.writeTextFile {
              inherit name;
              executable = true;
              destination = "/bin/${name}";
              text = builtins.readFile ./scripts/${name};
              checkPhase = ''
                ${pkgs.stdenv.shellDryRun} "$target"
              '';
              meta.mainProgram = name;
            };
        in [
          (script "diffex")
        ]);

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
