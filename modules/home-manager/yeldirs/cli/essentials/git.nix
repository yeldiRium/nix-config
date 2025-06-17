{
  config,
  lib,
  pkgs,
  ...
}: let
  shellScript = import ../../../../../lib/shellScript.nix pkgs;

  essentials = config.yeldirs.cli.essentials;
  cfg = config.yeldirs.cli.essentials.git;
in {
  options = {
    yeldirs.cli.essentials.git = {
      userEmail = lib.mkOption {
        type = lib.types.str;
        description = "The user email for commits";
      };
      signCommits = lib.mkEnableOption "commit signing";
      signingKey = lib.mkOption {
        type = lib.types.str;
        description = "Fingerprint for the key used to sign commits";
        default = "";
      };
      ignores = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Entries for the global .gitignore file";
        default = [];
      };
    };
  };

  config = lib.mkIf essentials.enable {
    assertions = [
      {
        assertion = cfg.signCommits == false || cfg.signingKey != "";
        message = "If commit signing is enabled, a signing key fingerprint must be set.";
      }
    ];

    programs = {
      git = {
        enable = true;

        userName = lib.mkDefault "Hannes Leutloff";
        userEmail = lib.mkDefault cfg.userEmail;

        extraConfig = {
          init.defaultBranch = "main";

          commit.gpgSign = cfg.signCommits;
          user.signing.key = cfg.signingKey;

          rerere.enabled = true;
        };

        ignores =
          [
            ".fuse_hidden*"
            ".vscode"
          ]
          ++ cfg.ignores;
      };

      zsh = {
        initContent = ''
          eval "$(${lib.getExe pkgs.unstable.git-bug} completion zsh)"
        '';
      };
    };

    home = {
      packages = with pkgs; [
        unstable.git-bug
        (shellScript ./scripts/is-git-bug-initialized)
      ];
      persistence."/persist/${config.home.homeDirectory}" = {
        directories = [
          ".config/git-bug"
        ];
      };
    };
  };
}
