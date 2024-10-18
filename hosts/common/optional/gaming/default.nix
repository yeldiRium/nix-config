{
  imports = [
    ./steam-hardware.nix
  ];

  programs = {
    xwayland.enable = true;
  };

  hardware.graphics.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
