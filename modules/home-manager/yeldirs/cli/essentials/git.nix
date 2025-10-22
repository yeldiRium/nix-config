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
      shellAliases =
        let
          branchName = # bash
            ''
              branchName=$(git branch --show-current --format="%(refname:short)")
            '';
          remoteBranchName = # bash
            ''
              upstreamBranchRefName=$(git config get "branch.''${branchName}.merge")
              upstreamBranchName=$(echo "''${upstreamBranchRefName}" | sed 's/refs\/heads\///')
              remoteName=$(${lib.getExe pkgs.y.git-find-remote})
              remoteBranchName="''${remoteName}/''${upstreamBranchName}"
            '';

        in
        {
          # convenience
          grt = ''cd "$(git rev-parse --show-toplevel || echo .)"'';

          # add
          ga = "git add";
          gapa = "git add --patch";

          # commit
          gcm = "git commit --verbose --message";
          "gc!" = "git commit --verbose --amend";
          "gcn!" = "git commit --verbose --no-edit --amend";

          # diff
          gd = "git diff";
          gdc = "git diff --cached";
          # range-diff
          grdu = # bash
            ''
              ${branchName}
              ${remoteBranchName}
              defaultBranch=$(${lib.getExe pkgs.y.git-find-default-branch})
              git range-diff "''${defaultBranch}..''${remoteBranchName}" "''${defaultBranch}..''${branchName}"
            '';

          # fetch
          gfa = "git fetch --all --tags --prune";

          # log
          glog = "git log --decorate --oneline --graph";
          gloga = "git log --decorate --oneline --graph --all";
          glogm = "git log --decorate --oneline --graph \"$(git symbolic-ref \"refs/remotes/$(${lib.getExe pkgs.y.git-find-remote})/HEAD\" --short)\" HEAD";
          glogu = # bash
            ''
              ${branchName}
              ${remoteBranchName}
              git log --decorate --oneline --graph "''${remoteBranchName}" HEAD
            '';

          # merge
          gm = "git merge";
          "gm!" = "git merge --no-edit";

          # pull
          gpl = "git pull";
          gplr = "git pull --rebase";

          # push
          gp = "git push";
          gpf = "git push --force-with-lease --force-if-includes";

          # rebase
          grb = "git rebase --interactive";
          "grb!" = "git rebase";
          grbc = "git rebase --continue";
          grba = "git rebase --abort";

          # stash
          gsta = "git stash push";
          gstau = "git stash push --all --include-untracked";
          gstap = "git stash push --patch";
          gstl = "git stash list";
          gsts = "git stash show --patch";
          gstaa = "git stash apply";
          gstp = "git stash pop";
          gstd = "git stash drop";

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

          y.git-find-default-branch
          y.git-find-remote
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
