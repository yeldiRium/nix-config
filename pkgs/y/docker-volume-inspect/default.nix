{ writeShellApplication }:
writeShellApplication {
  name = "docker-volume-inspect";
  text = builtins.readFile ./docker-volume-inspect;

  meta = {
    mainProgram = "docker-volume-inspect";
  };
}
