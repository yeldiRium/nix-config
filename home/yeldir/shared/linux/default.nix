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
      keyring.enable = true;
    };

    desktop = {
      essentials = {
        chrome = {
          enable = true;
          default = true;
        };
      };
    };
  };
}
