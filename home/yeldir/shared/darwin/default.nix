{inputs, ...}: {
  imports = [
    inputs.mac-app-util.homeManagerModules.default
  ];

  yeldirs = {
    system = {
      disable-impermanence = true;

      platform = "darwin";

      keyboardLayout = "de";
    };
  };
}
