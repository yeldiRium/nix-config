{ writeShellApplication, ttyplot }:
writeShellApplication {
  name = "watchcmd";
  text = builtins.readFile ./watchcmd;

  runtimeInputs = [
    ttyplot
  ];

  meta = {
    mainProgram = "watchcmd";
  };
}
