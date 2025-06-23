{
  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];

      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      warn-dirty = false;
    };

    optimise = {
      automatic = true;
    };
  };
}
