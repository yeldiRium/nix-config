{ writeShellApplication }:
writeShellApplication {
  name = "docker-volume-copy";
  text = builtins.readFile ./docker-volume-copy;

  meta = {
    mainProgram = "docker-volume-copy";
  };
}
