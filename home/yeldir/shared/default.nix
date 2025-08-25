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
          ssh = {
            includeWorkers = true;
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
          neovim = {
            supportedLanguages = [
              "bash"
              "docker"
              "json"
              "ledger"
              "lua"
              "markdown"
              "nix"
              "yaml"
            ];

            layout = {
              indentation-guides.enable = true;
            };

            blamer.enable = true;
            copilot.enable = false;
            debugging.enable = true;
            fold-cycle.enable = true;
            git.enable = true;
            illuminate.enable = true;
            lsp.enable = true;
            oil.enable = true;
            quickfilepicker = {
              grapple.enable = true;
            };
            telescope.enable = true;
            testing.enable = true;
            treesitter.enable = true;
            undotree.enable = true;
            which-key.enable = true;
            yazi.enable = true;
            zoom.enable = true;
          };
          yazi = {
            enableGui = true;
          };
        };

        office = {
          taskwarrior.enable = true;
        };

        ops = {
          fs-tools.enable = true;
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
