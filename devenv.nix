{
  pkgs,
  ...
}:
{
  packages = with pkgs; [
    argbash
    silver-searcher
  ];

  tasks = {
    "app:build".exec = "./scripts/build";
    "app:lint-fix".exec = "nix fmt";
  };

  git-hooks.hooks = {
    shellcheck.enable = true;
  };
}
