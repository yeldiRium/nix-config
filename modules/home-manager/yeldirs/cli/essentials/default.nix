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
    ./tmux.nix
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
        ijq
        yq
        silver-searcher
        btop
        zip
        unzip

        # nix utils
        alejandra

        # development
        devbox
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
