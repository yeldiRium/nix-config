{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    sops
  ];
  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = "/persist/sops/age/keys.txt";
  };
  sops = {
    defaultSopsFile = ../secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/persist/sops/age/keys.txt";
  };
}
