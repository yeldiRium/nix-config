{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.mac-app-util.homeManagerModules.default
    ./global
  ];

  hostName = "rekorder";

  wallpaper = pkgs.wallpapers.cyberpunk-rainy-alley;

  yeldirs = {
    system = {
      platform = "darwin";

      keyboardLayout = "de";
      keyboardVariant = "";
    };
    disable-impermanence = true;

    cli = {
      essentials = {
        zsh = {
          enable = true;
          enableSecretEnv = true;
        };

        bat.enable = true;
        git.enable = true;
        gpg = {
          enable = true;
          trustedPgpKeys = [
            ./pgp.asc
          ];
        };
        hstr.enable = true;
        ranger = {
          enable = true;
          enableGui = true;
        };
        ssh.enable = true;
        thefuck.enable = true;

        neovim = {
          enable = true;

          supportedLanguages = [
            "bash"
            "docker"
            "go"
            "javascript"
            "json"
            "ledger"
            "lua"
            "markdown"
            "nix"
            "poefilter"
            "typescript"
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
          obsidian.enable = true;
          telescope.enable = true;
          testing.enable = true;
          treesitter.enable = true;
          undotree.enable = true;
        };
      };
      ops = {
        colima.enable = true;
      };
    };

    desktop = {
      essentials = {
        kitty.enable = true;
      };
    };
  };
}
