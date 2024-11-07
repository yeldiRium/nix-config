{
  imports = [
    ./gamemode.nix
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

  systemd.extraConfig = "DefaultLimitNOFILE=134217727:268435454";
}
