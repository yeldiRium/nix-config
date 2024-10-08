{
  programs = {
    git = {
      enable = true;

      userName = "Hannes Leutloff";
      userEmail = "hannes.leutloff@yeldirium.de";

      extraConfig = {
        init.defaultBranch = "main";

        user.signing.key = "8DFC 1FE9 7A49 B7CE F042  DE06 BA23 9C41 39A9 A514";
        commit.gpgSign = true;

        rerere.enabled = true;
      };

      ignores = [
        ".vscode"
      ];
    };
  };
}
