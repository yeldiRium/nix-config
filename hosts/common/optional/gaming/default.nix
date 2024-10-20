{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./gamemode.nix
    ./steam.nix
  ];

  programs = {
    xwayland.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["amdgpu"];
}
