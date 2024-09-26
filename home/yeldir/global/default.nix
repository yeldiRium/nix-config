{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: {
  # You can import other home-manager modules here
  imports =
    [
      # If you want to use modules your own flake exports (from modules/home-manager):
      # outputs.homeManagerModules.example

      # Or modules exported from other flakes (such as nix-colors):
      # inputs.nix-colors.homeManagerModules.default

      # You can also split up your configuration and import pieces of it here:
      # ./nvim.nix
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      warn-dirty = false;
    };
  };

  home = {
    username = lib.mkDefault "yeldir";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "24.05";
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    neovim.enable = true;
  };

  systemd = {
    user.startServices = "sd-switch";
  };
}
