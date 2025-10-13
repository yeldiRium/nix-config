{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli) essentials;
  cfg = config.yeldirs.cli.essentials.git;
in
{
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
        default = [ ];
      };
      enableDelta = lib.mkOption {
        type = lib.types.bool;
        description = "delta diff tool";
        default = true;
      };
    };
  };

  config = lib.mkIf essentials.enable {
    assertions = [
      {
        assertion = !cfg.signCommits || cfg.signingKey != "";
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
        }
        // (lib.optionalAttrs cfg.enableDelta {
          core.pager = "${lib.getExe pkgs.delta}";
          pager.range-diff = "${lib.getExe pkgs.delta}";
          interactive.diffFilter = "${lib.getExe pkgs.delta} --color-only";
          merge.conflictStyle = "zdiff3";

          delta = {
            navigate = true;
            dark = true;
            line-numbers = true;
            side-by-side = true;
            syntax-theme = "Monokai Extended";
          };
        });

        ignores = [
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
      # ToDo: Write script that finds remote name.
      #       If only one remote exists, use that.
      #       Otherwise if one of the remotes is called "origin", use that.
      #       Otherwise fail and print an error.
      # ToDo: Write script that finds the default branch.
      #       If a "main" exists, use that.
      #       Otherwise if a "master" exists, use that.
      #       Otherwise fail and print an error.
      # ToDo: Add script that does `git switch --detach && reset --soft <default>`
      shellAliases =
        let
          upstreamName = "origin";
        in
        {
          # add
          ga = "git add";
          gapa = "git add --patch";

          # commit
          gcm = "git commit --verbose --message";
          "gc!" = "git commit --verbose --amend";
          "gcn!" = "git commit --verbose --no-edit --amend";

          # fetch
          gfa = "git fetch --all --tags --prune";

          # log
          glog = "git log --decorate --oneline --graph";
          gloga = "git log --decorate --oneline --graph --all";
          # ToDo: Use script that finds remote name here.
          glogm = "git log --decorate --oneline --graph $(git symbolic-ref refs/remotes/${upstreamName}/HEAD --short) HEAD";

          # merge
          gm = "git merge";
          "gm!" = "git merge --no-edit";

          # push
          gp = "git push";
          gpf = "git push --force-with-lease --force-if-includes";

          # status
          gst = "git status";
          gss = "git status --short --branch";

          # switch
          gsw = "git switch";
          gswc = "git switch --create";
          gswd = "git switch --detach";
        };

      packages =
        with pkgs;
        [
          unstable.git-bug
          (y.shellScript ./scripts/is-git-bug-initialized)
          (y.shellScript ./scripts/open-git-file)
        ]
        ++ (lib.optionals cfg.enableDelta [
          delta
        ]);
      persistence."/persist/${config.home.homeDirectory}" = {
        directories = [
          ".config/git-bug"
        ];
      };
    };
  };
}
