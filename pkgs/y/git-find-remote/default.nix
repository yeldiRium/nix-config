{
  bats,
  lib,
  silver-searcher,
  writeShellApplication,
}:
writeShellApplication {
  name = "git-find-remote";
  text = builtins.readFile ./git-find-remote;

  runtimeInputs = [
    silver-searcher
  ];

  derivationArgs = {
    checkInputs = [
      bats
    ];
  };
  checkPhase = # bash
    ''
      ${lib.getExe bats} test/
    '';

  meta = {
    mainProgram = "git-find-remote";
  };
}
