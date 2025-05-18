{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";

      # Keep the last 15 generations
      options = "--delete-generations +14";
    };
  };
}
