{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.obsidian;
in {
  options = {
    yeldirs.cli.essentials.neovim.obsidian = {
      enable = lib.mkEnableOption "obsidian";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the plugin obsidian to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = obsidian-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require('obsidian').setup({
              workspaces = {
                {
                  name = "obsidian",
                  path = "~/querbeet/workspace/obsidian/",
                },
              },
              mappings = {
                ["gf"] = {
                  action = function()
                    require("obsidian").get_client():command("ObsidianFollowLink", {})
                  end,
                  opts = { noremap = false, expr = true, buffer = true },
                },
                ["<C-o>"] = {
                  action = function()
                    require("obsidian").get_client():command("ObsidianQuickSwitch", {})
                  end,
                  opts = { noremap = false, buffer = true },
                },
              },
              picker = {
                name = "telescope.nvim",
              },
              daily_notes = {
                folder = "daily/log",
                date_format = "%Y-%m-%d %A",
                template = "templates/daily.md",
              },
              templates = {
                folder = "templates",
              },
              disable_frontmatter = true,
              ui = {
                enable = false,
              },
            })
            vim.keymap.set("n", "<leader>od", function()
              require("obsidian").get_client():command("ObsidianToday", {})
            end, { desc = "Search files in pwd" })
            vim.keymap.set("n", "<C-o>", telescope.git_files, { desc = "Search files in current git project" })
          '';
      }
    ];
  };
}
