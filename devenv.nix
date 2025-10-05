{
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

  git-hooks.hooks = {
    check-merge-conflicts.enable = true;
    check-shebang-scripts-are-executable.enable = true;
    deadnix = {
      enable = true;
      excludes = [ "hardware-configuration\.nix$" ];
    };
    end-of-file-fixer.enable = true;
    gitleaks = {
      enable = true;
      name = "Gitleaks";
      entry = "${lib.getExe pkgs.gitleaks} git --pre-commit --redact --staged --verbose";
      pass_filenames = false;
    };
    pre-commit-hook-ensure-sops.enable = true;
    shellcheck.enable = true;
    trim-trailing-whitespace.enable = true;
  };
}
