{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";

      # Keep the last 15 generations
      options = "--delete-older-than +15";
    };
  };
}
