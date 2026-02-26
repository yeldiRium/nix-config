{ lib, ... }:
{
  yeldirs = {
    system = {
      platform = "linux";

      keyboardLayout = "de";
      sops = {
        enable = true;
        sopsFile = ./../../secrets.yaml;
        keyFile = "/persist/sops/age/keys.txt";
      };
      mounts = {
        datengrab.enable = true;
      };
      keyring.enable = true;
    };

    desktop = {
      enable = lib.mkDefault true;

      essentials = {
        chrome = {
          enable = true;
          default = true;
        };
      };
    };
  };
}
