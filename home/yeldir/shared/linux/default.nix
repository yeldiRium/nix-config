{
  yeldirs = {
    system = {
      platform = "linux";

      keyboardLayout = "de";
      sops = {
        enable = true;
        sopsFile = ./../../secrets.yaml;
        keyFile = "/persist/sops/age/keys.txt";
      };
      mounts = {
        datengrab.enable = true;
      };
    };

    cli = {
      essentials = {
        enable = true;
        zsh = {
          enable = true;
          enableSecretEnv = true;
        };

        git.enable = true;
        gpg = {
          enable = true;
          trustedPgpKeys = [
            ./../../pgp.asc
          ];
        };
        isd.enable = true;
        ranger = {
          enable = true;
          enableGui = true;
        };
        ssh.enable = true;

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
          firenvim.enable = true;
          fold-cycle.enable = true;
          git.enable = true;
          harpoon2.enable = true;
          lsp.enable = true;
          nrvimr.enable = true;
          telescope.enable = true;
          testing.enable = true;
          treesitter.enable = true;
          undotree.enable = true;
        };
      };

      development = {
        gh.enable = true;
        qmk.enable = true;
      };

      office = {
        taskwarrior.enable = true;
        yt-dlp.enable = true;
      };
    };

    desktop = {
      communication = {
        matrix.enable = true;
      };
      essentials = {
        kitty.enable = true;
      };
      office = {
        zotero.enable = true;
      };
    };
  };
}
