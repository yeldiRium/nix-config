{
  config,
  lib,
  pkgs,
  ...
}:
{
  packages = with pkgs; [
    git
    git-bug

    # Bash
    argbash
    silver-searcher

    # Go
    golangci-lint
    gotestsum
  ];

  languages = {
    go = {
      enable = true;
      enableHardeningWorkaround = true;
    };

    nix = {
      enable = true;
      lsp.package = pkgs.nixd;
    };
  };

  tasks = {
    "app:build:bash".exec = "./scripts/build";
  };

  git-hooks.hooks =
    let
      nixIgnores = [
        "hardware-configuration.nix"

        # Contains pipe operators, which statix does not support.
        # Remove this once https://github.com/oppiliappan/statix/issues/139 is resolved.
        "lib/y/workers.nix"
      ];
    in
    {
      check-merge-conflicts.enable = true;
      end-of-file-fixer.enable = true;
      gitleaks = {
        enable = true;
        name = "Gitleaks";
        entry = "${lib.getExe pkgs.gitleaks} git --pre-commit --redact --staged --verbose";
        pass_filenames = false;
      };
      pre-commit-hook-ensure-sops.enable = true;
      trim-trailing-whitespace.enable = true;

      # Bash
      build-bash = {
        enable = true;
        entry = config.tasks."app:build:bash".exec;
        types = [ "bash" ];
        pass_filenames = false;
      };
      check-shebang-scripts-are-executable.enable = true;
      shellcheck.enable = true;

      # Nix
      deadnix = {
        enable = true;
        excludes = nixIgnores;
      };
      nixfmt.enable = true;
      statix = {
        enable = true;
        excludes = nixIgnores;
        settings.ignore = nixIgnores;
      };

      # Go
      gofmt.enable = true;
      golangci-lint-monorepo = {
        enable = true;
        entry =
          (pkgs.writeShellScript "golangci-lint-monorepo" # bash
            ''
              errors=0
              for dir in $(echo "$@" | xargs -n1 dirname | sort -u); do
                cd "''${dir}"
                if ! ${lib.getExe pkgs.golangci-lint} run; then
                  ((errors += 1))
                fi
                cd -
              done

              if [[ $errors -gt 0 ]]; then
                exit 1
              fi
            ''
          ).outPath;
        language = "system";
        files = "\\.go$";
        require_serial = true;
      };
    };
}
