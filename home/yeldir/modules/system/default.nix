{
  config,
  lib,
  ...
}: {
  imports = [
    ./mounts
  ];

  options = {
    yeldirs.system.platform = lib.mkOption {
      type = lib.types.enum ["linux" "darwin"];
      description = "The system platform";
    };

    yeldirs.system.keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "de";
      description = "The keyboard layout to use.";
    };
    yeldirs.system.keyboardVariant = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The keyboard variant to use.";
    };
  };

  config = {
    assertions = [
      {
        assertion = config.yeldirs.system.platform != "";
        message = "Platform must be set to either 'linux' or 'darwin'.";
      }
    ];
  };
}
