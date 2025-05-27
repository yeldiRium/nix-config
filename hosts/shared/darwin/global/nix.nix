{
  nix = {
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };

      # Keep the last 15 generations
      options = "--delete-older-than +15";
    };
  };
}
