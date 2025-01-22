{
  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];

      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      # Keep the last 15 generations
      options = "--delete-older-than +15";
    };
  };
}
