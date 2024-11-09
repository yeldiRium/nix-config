{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.neovim.copilot;
in {
  options = {
    yeldirs.cli.neovim.copilot.enable = lib.mkEnableOption "neovim plugin for github copilot";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.neovim.enable;
        message = "neovim must be enabled for the github copilot integration to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = copilot-vim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            -- Default keybinding for github copilot it <Tab>, which I like.
            -- Binding it explicitly somehow didn't work, so I'll just leave it as-is.
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
            copilot.setup({})

            -- Open quick chat without any reference to code
            vim.keymap.set("n", "<leader>ccc", function()
              copilot.toggle()
            end)

            -- Run copilot with current buffer as input
            vim.keymap.set("n", "<leader>ccq", function()
              local input = vim.fn.input("Quick Chat: ")
              if input ~= "" then
                require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
              end
            end)

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
            end)
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
