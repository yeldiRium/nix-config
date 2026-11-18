# quickstart
## New host with full disk encryption and initrd-ssh
Compare `datengrab`.

These steps can be run automatically using ./quickstart.bash.
Do the steps until including 0. manually, then run the script.

-2. Create new host config, generate hardware config, check right disk device, find ethernet kernel modules for initrd, etc.
-1. Optional: connect to wifi
0. `cd ~ && git clone https://github.com/yeldirium/nix-config && cd nix-config`
1. Create encryption key
1.1. `sudo mkdir -p /persist/luks`
1.2. `sudo vim /persist/luks/secret.key` and enter the encryption key
2. Format disks with `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode destroy,format,mount --flake .#<hostname>`
3. Create workspace and move nix config
3.1. `sudo mkdir -p /mnt/persist/home/yeldir/querbeet/workspace`
3.2. `sudo chown -R 1000:100 /mnt/persist/home/yeldir`
3.3. `sudo mv ~/nix-config /mnt/persist/home/yeldir/querbeet/workspace/`
3.4. `cd /mnt/persist/home/yeldir/querbeet/workspace/nix-config`
4. Create hostkey for initrd
4.1. `sudo mkdir -p /mnt/etc/ssh`
4.2. `sudo ssh-keygen -t ed25519 -N "" -f /mnt/etc/ssh/initrd`
4.3. `sudo chmod 600 /mnt/etc/ssh/initrd`
5. Optional: wpa_supplicant
5.1. `wpa_passphrase "<ssid>" "<password>" | sed '/#psk/d' > ~/wpa_supplicant.conf"
5.3. `sudo chown root:root /home/nixos/wpa_supplicant.conf`
5.2. `sudo mv /home/nixos/wpa_supplicant.conf /mnt/etc/wpa_supplicant/wpa_supplicant-wifi.conf`
6. Put age key in /mnt/persist/sops/age/keys.txt
6.1. Optional: mount usb stick or somthing else to get the prepared age keys
6.2. `sudo mkdir -p /mnt/persist/sops/age`
6.3. `sudo cp <path-to>/keys.txt /mnt/persist/sops/age/keys.txt`
7. Move disk encryption key
7.1. `sudo mkdir -p /mnt/persist/luks`
7.2. `sudo cp /persist/luks/secret.key /mnt/persist/luks/secret.key`
8. Check if ethernet kernel module is correct (`lspci -v | grep -iA8 'network\|ethernet'`)
8.1. Optional: Set the correct kernel modules in the hostconfig
9. Install nixos using `sudo nixos-install --flake .#<hostname>`
10. Unlock luks containers manually, delete initrd key, generate new one at /etc/ssh/initrd, as described in 4.
