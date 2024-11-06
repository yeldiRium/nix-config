{lib, ...}: {
  options = {
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
}
