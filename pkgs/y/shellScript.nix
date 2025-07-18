{pkgs, ...}: path: let
  name = builtins.baseNameOf path;
in
  pkgs.writeTextFile {
    inherit name;
    executable = true;
    destination = "/bin/${name}";
    text = builtins.readFile path;
    checkPhase = ''
      ${pkgs.stdenv.shellDryRun} "$target"
    '';
    meta.mainProgram = name;
  }
