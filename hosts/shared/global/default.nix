{
  outputs,
  ...
}:
{
  imports = [
    ./nix.nix
    ./zsh.nix
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
}
