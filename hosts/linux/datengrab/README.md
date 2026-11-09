# datengrab
## Install command

0. `cd ~ && git clone https://github.com/yeldirium/nix-config`
1. Put file with encryption key in /tmp/secret.key
2. Format disks with `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode destroy,format,mount --flake .#datengrab`
3.1. `sudo mkdir -p /mnt/persist/home/yeldir/querbeet/workspace`
3.2. `sudo chown -R 1000:100 /mnt/presist/home/yeldir`
3.3. `sudo mv ~/nix-config /mnt/persist/home/yeldir/querbeet/workspace/`
4. Put hostkey in /mnt/etc/ssh/initrd
4.1. `sudo ssh-keygen -t ed25519 -N "" -f /mnt/etc/ssh/initrd`
4.2. `sudo chmod 600 /mnt/etc/ssh/initrd`
5. Put age key in /mnt/persist/sops/age/keys.txt
6.1. Put file with encryption key in /mnt/persist/luks/secret.key
6.2. Adjust path to encryption key in disks.nix
6.3. This won't help, since /mnt/presist ist part of the encrypted disks, so only after unlocking it can it be used. This at least simplifies unlocking the four HDDs though.
7. Check if ethernet kernel module is correct (`lspci -v | grep -iA8 'network\|ethernet'`)
8. Install nixos using `sudo nixos-install --flake .#datengrab`
9. Unlock luks containers manually, delete initrd key, generate new one at /etc/ssh/initrd
