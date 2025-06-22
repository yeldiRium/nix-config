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
      ];
      warn-dirty = false;
    };

    optimise = {
      automatic = true;
    };
  };
}
