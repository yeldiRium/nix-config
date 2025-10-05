{
  config,
  lib,
  pkgs,
  ...
}:
{
  packages = with pkgs; [
    argbash
    silver-searcher
  ];

  languages.nix = {
    enable = true;
    lsp.package = pkgs.nixd;
  };

  tasks = {
    "app:build".exec = "./scripts/build";
    "app:lint-fix".exec = "nix fmt";
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
      build = {
        enable = true;
        entry = config.tasks."app:build".exec;
        types = [ "bash" ];
        pass_filenames = false;
      };

      check-merge-conflicts.enable = true;
      check-shebang-scripts-are-executable.enable = true;
      deadnix = {
        enable = true;
        excludes = nixIgnores;
      };
      end-of-file-fixer.enable = true;
      gitleaks = {
        enable = true;
        name = "Gitleaks";
        entry = "${lib.getExe pkgs.gitleaks} git --pre-commit --redact --staged --verbose";
        pass_filenames = false;
      };
      nixfmt-rfc-style.enable = true;
      pre-commit-hook-ensure-sops.enable = true;
      shellcheck.enable = true;
      statix = {
        enable = true;
        excludes = nixIgnores;
        settings.ignore = nixIgnores;
      };
      trim-trailing-whitespace.enable = true;
    };
}
