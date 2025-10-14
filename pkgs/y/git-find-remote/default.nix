{
  buildGoModule,
}:
buildGoModule {
  name = "git-find-remote";
  src = builtins.path {
    path = ./.;
  };

  vendorHash = null;
}
