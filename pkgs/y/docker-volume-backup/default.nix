{ writeShellApplication }:
writeShellApplication {
  name = "docker-volume-backup";
  text = builtins.readFile ./docker-volume-backup;

  meta = {
    mainProgram = "docker-volume-backup";
  };
}
