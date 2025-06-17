# Provisioning a hetzner cloud remote server

1. get a server via the ui and give it a unique name using rand5
2. find ipv6 address, ipv6 interface mac address
3. create a new host with hostname matching the unique name and hostid likewise
4. configure ipv6 address and interface mac address
5. provision server with `nixos-anywhere --flake $FLAKE#worker --target-host root@<ipv6>`
6. you can now login via `ssh -i <pubkey> worker@ipv6`
7. any further updates can be done using `nixos-rebuild switch --flake $FLAKE#worker --target-host worker@<ipv6> --use-remote-sudo`
