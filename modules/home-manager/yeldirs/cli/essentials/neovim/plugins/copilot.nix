{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.copilot;
in {
  options = {
    yeldirs.cli.essentials.neovim.copilot.enable = lib.mkEnableOption "neovim plugin for github copilot";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      plenary-nvim
      {
        plugin = copilot-vim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            vim.g.copilot_filetypes = {
              ledger = false,
            }

            local copilotEnabled = false
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    vim.cmd(':Copilot disable')
                end
            })
            vim.keymap.set("n", "<leader>cct", function()
                if copilotEnabled then
                    vim.cmd(':Copilot disable')
                    print("Copilot disabled")
                else
                    vim.cmd(':Copilot enable')
                    print("Copilot enabled")
                end
                copilotEnabled = not copilotEnabled
            end, { desc = "Toggle copilot suggestions" })
          '';
      }
      {
        plugin = CopilotChat-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local copilot = require("CopilotChat")
            copilot.setup({
              model = "gpt-4",
            })

            -- Open quick chat without any reference to code
            vim.keymap.set("n", "<leader>ccc", function()
              copilot.toggle()
            end, { desc = "Toggle copilot chat sidebar" })

            vim.keymap.set("n", "<leader>ccm", function()
              vim.cmd(':CopilotChatModel')
            end, { desc = "Choose copilot model for chat" })

            -- Run copilot with current buffer as input
            vim.keymap.set("n", "<leader>ccq", function()
              local input = vim.fn.input("Quick Chat: ")
              if input ~= "" then
                require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
              end
            end, { desc = "Quick copilot chat with current buffer as input" })

            -- Run copilot inline in floating window
            vim.keymap.set("n", "<leader>cci", function()
              copilot.open({
                window = {
                  layout = "float",
                  relative = "cursor",
                  width = 1,
                  height = 0.4,
                  row = 1,
                },
              })
            end, { desc = "Run copilot in floating inline window" })
          '';
      }
    ];

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".config/github-copilot"
        ];
      };
    };
  };
}
