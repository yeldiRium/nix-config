{inputs, lib, ...}: {
  imports = [
    inputs.mac-app-util.homeManagerModules.default
  ];

  yeldirs = {
    cli.essentials.git.signCommits = lib.mkForce false;
    system = {
      disable-impermanence = true;

      platform = "darwin";

      keyboardLayout = "de";
    };
  };
}
