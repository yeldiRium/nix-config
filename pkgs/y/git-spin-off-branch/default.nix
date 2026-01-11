{ writeShellApplication }:
writeShellApplication {
  name = "git-spin-off-branch";
  text = builtins.readFile ./git-spin-off-branch;

  meta = {
    mainProgram = "git-spin-off-branch";
    description = "Create a new branch at HEAD, reset the active branch to its upstream, and switch to the newly created branch.";
  };
}
