# Workers

I've started building scripts to set up workers easily.
I'm thinking about maybe using this mechanism to provision k3s nodes or something similar.

The mechanism is built to work with Hetzner Cloud servers.
The configuration is taken from the [nixos-anywhere-examples](https://github.com/nix-community/nixos-anywhere-examples/blob/main/configuration.nix) and refined for my use.

## Adding a new worker

1. Generate a 5-char string (using [rand5](./modules/home-manager/yeldirs/cli/essentials/scripts/rand5) (we'll call this the server's shortname)
2. Create a new server in Hetzner Cloud and set its hostname to "worker-${shortname}"
3. Run the [worker-add script](./scripts/worker-add) and pass it the shortname and the server's ipv6 address
    - Example: `./scripts/worker-add 12345 2a01:4f8:5521:e1bd::1`
4. Build a new config for your work computer, since adding a new worker automatically creates a new ssh config
5. Commit the change to workers.json

## Updating a worker

1. Run the [worker-update script](./scripts/worker-update) and pass it the worker's shortname

## Removing a worker

1. Run the [worker-rm script](./scripts/worker-rm) and pass it the worker's shortname
2. Rebuild your system to remove the ssh_config entry
