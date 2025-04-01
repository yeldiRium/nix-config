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
            enable = true;
            enableSecretEnv = true;
          };
          hstr = {
            enable = true;
          };
          git = {
            enable = true;
            userEmail = "hannes.leutloff@yeldirium.de";
            signCommits = true;
            signingKey = "8DFC 1FE9 7A49 B7CE F042  DE06 BA23 9C41 39A9 A514";
          };
          gpg = {
            enable = true;
            trustedPgpKeys = [
              ./../pgp.asc
            ];
          };
          neovim = {
            enable = true;

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

            copilot.enable = true;
            debugging.enable = true;
            early-retirement.enable = true;
            fidget.enable = true;
            firenvim.enable = true;
            fold-cycle.enable = true;
            git.enable = true;
            harpoon2.enable = true;
            illuminate.enable = true;
            lsp.enable = true;
            nrvimr.enable = true;
            telescope.enable = true;
            testing.enable = true;
            treesitter.enable = true;
            undotree.enable = true;
            vim-tmux-navigator.enable = true;
            zoom.enable = true;
          };
          ranger = {
            enable = true;
            enableGui = true;
          };
          ssh.enable = true;
          tmux = {
            enable = true;
            vim-tmux-navigator.enable = true;
          };
        };

        office = {
          taskwarrior.enable = true;
        };
      };

      desktop = {
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
