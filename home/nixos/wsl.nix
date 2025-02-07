{pkgs, ...}: {
  imports = [
    ../shared
  ];

  wallpaper = pkgs.wallpapers.cyberpunk-living-quarter;

  yeldirs = {
    system = {
      disable-impermanence = true;

      username = "nixos";
      hostName = "wsl";
      platform = "linux";

      keyboardLayout = "de";
      keyboardVariant = "";
    };

    cli = {
      essentials = {
        enable = true;

        zsh = {
          enable = true;
        };

        git = {
          enable = true;
          userEmail = "tbd";
          signCommits = true;
          signingKey = "tbd";
        };
        gpg = {
          enable = true;
        };
        ranger = {
          enable = true;
        };
        ssh = {
          enable = true;
          excludePrivate = true;
        };

        neovim = {
          enable = true;

          supportedLanguages = [
            "bash"
            "docker"
            "go"
            "javascript"
            "json"
            "lua"
            "markdown"
            "nix"
            "typescript"
            "yaml"
          ];

          layout = {
            indentation-guides.enable = true;
          };

          copilot.enable = true;
          debugging.enable = true;
          early-retirement.enable = true;
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

      ops = {
        colima.enable = true;
        k9s.enable = true;
        kubectl.enable = true;
        lazydocker.enable = true;
      };
    };
  };

  home = {
    shellAliases = {
      nbuild = "sudo nixos-rebuild build --flake $FLAKE#wsl --impure";
      nboot = "sudo nixos-rebuild boot --flake $FLAKE#wsl --impure";
      nswitch = "sudo nixos-rebuild switch --flake $FLAKE#wsl --impure";
      nrepl = "sudo nixos-rebuild repl --flake $FLAKE#wsl --impure";
      nrollback = "sudo nixos-rebuild switch --flake $FLAKE#wsl --impure --rollback";
    };
  };

  home = {
    stateVersion = "24.05";
  };
}
