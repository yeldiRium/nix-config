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

    cli = {
      essentials = {
        isd.enable = true;
      };
    };
  };
}
