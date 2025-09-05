{
  config,
  inputs,
  lib,
  modulesPath,
  worker,
  ...
}: {
  assertions = [
    {
      assertion = lib.y.workers.count == 0 || (lib.filter (w: w.k3s.clusterInit) lib.y.workers.workersList |> lib.length) == 1;
      message = "To create a cluster, exactly one cluster init must exist";
    }
    {
      assertion = lib.y.workers.count == 0 || lib.y.workers.serverCount > 0;
      message = "To create a cluster, at least one server must exist";
    }
  ];

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
    inputs.disko.nixosModules.default
    ./disko.nix

    ../../shared/global
    ../shared/global

    ../shared/users/worker
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = worker.hostName;
    hostId = worker.hostId;
    useDHCP = false;
  };
  systemd.network = {
    enable = true;
    networks."30-wan" = {
      matchConfig.Name = "enp1s0";
      address = [
        "${worker.ipv6}/64"
      ];
      routes = [
        # Hetzner uses this ipv6 as gateway by default.
        {Gateway = "fe80::1";}
      ];
    };
  };
  services = {
    openssh = {
      enable = true;
      ports = [ 58008 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    fail2ban.enable = true;

    k3s = {
      enable = true;

      role =
        if worker.k3s.server
        then "server"
        else "agent";
      clusterInit = worker.k3s.clusterInit;
      serverAddr =
        if worker.k3s.clusterInit
        then ""
        else lib.y.workers.k3s.primaryName;
      tokenFile = config.sops.secrets.k3sToken.path;

      extraFlags = [
        "--write-kubeconfig-mode 644"
      ];
      gracefulNodeShutdown.enable = true;
    };
  };
  virtualisation.docker.enable = true;

  yeldirs = {
    system = {
      sops = {
        enable = true;
        keyFile = "/root/keys.txt";
      };
      tailscale.enable = true;
    };
  };
  sops.secrets.k3sToken = {
    sopsFile = ./secrets.yaml;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCf4PuMuh6umz5hvl3u0sT20TP6+EKnOHKjy3uUjYCMjXMtjC83u5TKEl//oZ70g96Kn5w3KEN169ektClvHFJx8nOiZXAI617xVjTkYHtbpDaZOyaPNER23TQ+BNDarhAjtY9RAjgsO0M0wqfg69ElP6+UFl/MM+txjGnf3NasaDto5/bRNIBssBg++FI9xUHW/urD6hddRZ8iBIHxud8qezM9/a6+Q2/5AhBOmJy4MysWea1PP8jA2kbSDjUCNGA4w24pJzyVU8qB8WMWfIkkvUFCSQ/o0UZ133eoEZBGdTMW/oxI/wsUOqyBvbAkpJWPJH4LQqfopLfPjguI5QXj hannes.leutloff@yeldirium.de"
  ];

  security.sudo.wheelNeedsPassword = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05";
}
