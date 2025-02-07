{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.git;
in {
  options = {
    yeldirs.cli.essentials.git = {
      enable = lib.mkEnableOption "git";
      userEmail = lib.mkOption {
        type = lib.types.str;
        description = "The user email for commits";
      };
      signCommits = lib.mkEnableOption "commit signing";
      signingKey = lib.mkOption {
        type = lib.types.str;
        description = "Fingerprint for the key used to sign commits";
      };
    };
  };
  config = lib.mkIf cfg.enable {
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

        ignores = [
          ".fuse_hidden*"
          ".vscode"
        ];
      };
    };
  };
}
