{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gnome.gnome-keyring
  ];
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
}
