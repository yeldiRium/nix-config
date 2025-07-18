{
  inputs,
  lib,
  outputs,
  ...
}: {
  config = {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      extraSpecialArgs = {inherit inputs lib outputs;};
    };
  };
}
