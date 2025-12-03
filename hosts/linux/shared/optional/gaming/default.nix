{
  imports = [
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

  # Many games error with "Too many open files" with the default setting of 1024:524288.
  # I've tried a few very high values and this currently works okay-ish. Subject to change.
  # Notes on this in obsidian.
  systemd.settings.Manager = {
    DefaultLimitNOFILE = "1024:1048576";
  };
}
