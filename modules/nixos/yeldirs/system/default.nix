{
  imports = [
    ./disko
    ./impermanence
    ./zfs

    ./backup.nix
    ./gitops.nix
    ./networking.nix
    ./quiet-boot.nix
    ./remote-shutdown.nix
    ./sops.nix
    ./tailscale.nix
  ];
}
