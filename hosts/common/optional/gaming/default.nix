{pkgs, ...}: {
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

    # https://nixos.wiki/wiki/Steam#Changing_the_driver_on_AMD_GPUs
    extraPackages = [pkgs.amdvlk];
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  };

  systemd.extraConfig = "DefaultLimitNOFILE=134217727:268435454";
}
