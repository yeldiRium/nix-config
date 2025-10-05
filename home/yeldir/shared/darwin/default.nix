{ inputs, lib, ... }:
{
  imports = [
    inputs.mac-app-util.homeManagerModules.default
  ];

  yeldirs = {
    cli.essentials.git.signCommits = lib.mkForce false;
    system = {
      disable-impermanence = true;

      platform = "darwin";

      keyboardLayout = "de";
      sops = {
        enable = true;
        sopsFile = ../../secrets.yaml;
        keyFile = "/Users/yeldir/querbeet/keys.txt";
      };
    };
  };

  targets.darwin = {
    defaults = {
      "com.apple.dock" = {
        autohide = true;
      };
      "com.apple.controlcenter" = {
        BatteryShowPercentage = "YES";
      };
      "com.apple.menuextra.clock" = {
        IsAnalog = false;
        Show24Hour = true;
        ShowAMPM = false;
        ShowDate = 1;
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
        ShowSeconds = true;
      };
    };
  };
}
