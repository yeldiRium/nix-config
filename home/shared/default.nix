{
  outputs,
  ...
}: {
  imports = builtins.attrValues outputs.homeManagerModules;
}
