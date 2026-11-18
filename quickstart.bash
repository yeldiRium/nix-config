#!/usr/bin/env bash

set -euo pipefail

printf "Before running this script, make sure you have your age key accessible somewhere.\n"
read -p "Continue? (yes/no) " -r
if [[ "${REPLY}" != "yes" ]]; then
	printf "Aborting...\n"
	exit 1
fi

printf "What host are you setting up?\n"
read -r hostname

printf "Do you need wifi? (yes/no)\n"
read -r wifi

# 1. Create encryption key
printf "Creating encryption key file...\n"
sudo mkdir -p /persist/luks
secretFile=$(mktemp)
cat <<EOF > "${secretFile}"
	# Replace this line with the encryption key for your disks
EOF
vim "${secretFile}"
sudo chown root:root "${secretFile}"
sudo mv "${secretFile}" /persist/luks/secret.key

# 2. Format disks
printf "Destructively formatting disks...\n"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode destroy,format,mount --flake ".#${hostname}"

# 3. Create workspace and move nix-config
printf "Creating workspace and moving nix-config...\n"
sudo mkdir -p /mnt/persist/home/yeldir/querbeet/workspace
sudo chown -R 1000:100 /mnt/persist/home/yeldir
sudo mv ~/nix-config /mnt/persist/home/yeldir/querbeet/workspace/
cd /mnt/persist/home/yeldir/querbeet/workspace/nix-config

# 4. Create hostkey for initrd
printf "Creating hostkey for initrd...\n"
sudo mkdir -p /mnt/etc/ssh
sudo ssh-keygen -t ed25519 -N "" -f /mnt/etc/ssh/initrd
sudo chmod 600 /mnt/etc/ssh/initrd

# 5. Optional: wpa_supplicant
if [[ "${wifi}" == "yes" ]]; then
	printf "Generating wpa_suplicant config...\n"
	printf "What's your wifi's SSID?\n"
	read -r wifi_ssid
	printf "What's your wifi's password?\n"
	read -rs wifi_password
	wpaSupplicantFile=$(mktemp)
	wpa_passphrase "${wifi_ssid}" "${wifi_password}" | sed '/#psk/d' > "${wpaSupplicantFile}"
	sudo chown root:root "${wpaSupplicantFile}"
	sudo mv "${wpaSupplicantFile}" /mnt/etc/wpa_supplicant/wpa_supplicant-wifi.conf
fi

# 6. Put age key in /mnt/persist/sops/age/keys.txt
printf "Bringing age key in position...\n"
printf "Where is your age key?\n"
read -r ageKeyFile
sudo mkdir -p /mnt/persist/sops/age
sudo cp "${ageKeyFile}" /mnt/persist/sops/age/keys.txt

# 7. Move disk encryption key
printf "Moving disk encryption key...\n"
sudo mkdir -p /mnt/persist/luks
sudo cp /persist/luks/secret.key /mnt/persist/luks/secret.key

# 9. Install nixos
printf "Installing nixos...\n"
sudo nixos-install --flake ".#${hostname}"

printf "Now reboot.\n"
printf "After reboot, unlock luks manually once and regenerate initrd host key.\n"
printf "See step 4 in QUICKSTART.md\n"
