{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  system.stateVersion = "25.11"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    git
  ];

  users.users."yeldir" = {
    isNormalUser = true;
    initialPassword = "12345";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
