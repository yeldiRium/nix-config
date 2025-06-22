{
  inputs,
  outputs,
  ...
}: {
  config = {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      extraSpecialArgs = {inherit inputs outputs;};
    };
  };
}
