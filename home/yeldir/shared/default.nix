{
  config = {
    yeldirs = {
      system = {
        username = "yeldir";
      };

      cli = {
        essentials = {
          enable = true;
          zsh = {
            enableSecretEnv = true;
          };
          git = {
            userEmail = "hannes.leutloff@yeldirium.de";
            signCommits = true;
            signingKey = "8DFC 1FE9 7A49 B7CE F042  DE06 BA23 9C41 39A9 A514";
          };
          gpg = {
            trustedPgpKeys = [
              ./../pgp.asc
            ];
          };
          yazi = {
            enableGui = true;
          };
        };

        office = {
          taskwarrior.enable = true;
        };
      };

      desktop = {
        communication = {
          telegram.enable = true;
        };

        essentials = {
          kitty.enable = true;
        };

        office = {
          zotero.enable = true;
        };
      };
    };
  };
}
