{
  inputs,
  outputs,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useGlobalPackages = true;
    extraSpecialArgs = {inherit inputs outputs;};
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver = {
    xkb = {
      layout = "de";
      variant = "neo";
    };
  };
}
