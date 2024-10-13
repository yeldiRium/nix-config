{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  environment.persistence = {
    "/persist/system" = {
      directories = [
        "/var/lib/bluetooth" # TODO: move to optional bluetooth module
      ];
    };
  };
}
