{
  hardware.bluetooth = {
    enable = true;
  };

  environment.persistence = {
    "/persist/system" = {
      directories = [
        "/var/lib/bluetooth" # TODO: move to optional bluetooth module
      ];
    };
  };
}
