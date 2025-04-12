{
  imports = [
    ./input-remapper.nix
    ./gamemode.nix
    ./steam.nix
  ];

  programs = {
    xwayland.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # https://nixos.wiki/wiki/Steam#Changing_the_driver_on_AMD_GPUs
  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
  };

  # Many games error with "Too many open files" with the default setting of 1024:524288.
  # I've tried a few very high values and this currently works okay-ish. Subject to change.
  # Notes on this in obsidian.
  systemd.extraConfig = "DefaultLimitNOFILE=1024:1048576";
}
