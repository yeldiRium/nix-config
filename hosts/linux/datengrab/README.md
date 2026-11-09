# datengrab
## Install command

0. Clone this repo anywhere
1. Put file with encryption key in /tmp/secret.key
2. Format disks with `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode destroy,format,mount --flake .#datengrab`
3. Move nix config to /mnt/home/yeldir/querbeet/workspace/nix-config
4. Put hostkey in /mnt/etc/ssh/initrd
5. Put age key in /mnt/persist/sops/age/keys.txt
6.1. Put file with encryption key in /mnt/persist/luks/secret.key
6.2. Adjust path to encryption key in disks.nix
7. Install nixos using `sudo nixos-install --flake .#datengrab`
8. Unlock luks containers manually, delete initrd key, generate new one at /etc/ssh/initrd
