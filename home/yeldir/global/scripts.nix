{pkgs, ...}: {
  home = let
    script = name:
      pkgs.writeTextFile {
        inherit name;
        executable = true;
        destination = "/bin/${name}";
        text = builtins.readFile ./scripts/${name}.sh;
        checkPhase = ''
          ${pkgs.stdenv.shellDryRun} "$target"
        '';
        meta.mainProgram = name;
      };
  in {
    packages = with pkgs; [
      (script "openfilecount")
    ];
  };
}
