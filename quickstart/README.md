# Quickstart

1. `sudo su`
3. Find your system disk device using `lsblk`
4. Put it in the config file at the appropriate place
5. Run `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix --arg device '"/dev/<device here>"'`
6. Run `mkdir -p /mnt/etc/nixos && cp -r . /mnt/etc/nixos && cd /mnt/etc/nixos`
6. Run `nixos-generate-config --no-filesystems --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix`
8. Run `nixos-install --root /mnt --flake /mnt/etc/nixos#default`
