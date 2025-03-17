{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.debugging;
  supportedLanguages = config.yeldirs.cli.essentials.neovim.supportedLanguages;

  languageActive = language: lib.elem language supportedLanguages;
  optionals = language: list: lib.optionals (languageActive language) list;
in {
  options = {
    yeldirs.cli.essentials.neovim.debugging.enable = lib.mkEnableOption "neovim debugging support";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the debugging support to work";
      }
    ];

    # DAP servers
    home.packages = with pkgs; (optionals "go" [
      unstable.delve
    ]);

    home.sessionVariables = lib.mkIf (languageActive "go") {
      # This is necessary to make delve work. Some weird CGO/gcc bullshit.
      NIX_HARDENING_ENABLE = "";
    };
    programs.neovim.plugins = with pkgs.unstable.vimPlugins;
      [
        # dependencies
        nvim-nio

        {
          plugin = nvim-dap;
          type = "lua";
          config = lib.concatLines [
            /*
            lua
            */
            ''
              local dap = require("dap")

              vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = ""})
              vim.fn.sign_define("DapStopped",{ text = "▶", texthl = "", linehl = "", numhl = ""})

              vim.keymap.set("n", "<leader>cdb", dap.toggle_breakpoint)
              vim.keymap.set("n", "<leader>cdc", dap.continue)
              vim.keymap.set("n", "<leader>cdC", dap.terminate)

              vim.keymap.set("n", "<leader>cdo", dap.step_over) -- Step over
              vim.keymap.set("n", "<leader>cdi", dap.step_into) -- Step into
              vim.keymap.set("n", "<leader>cdx", dap.step_out) -- Step out
            ''
            (
              if languageActive "go"
              then
                /*
                lua
                */
                ''
                ''
              else ""
            )
          ];
        }
        {
          plugin = nvim-dap-ui;
          type = "lua";
          config =
            /*
            lua
            */
            ''
              local dap = require("dap")
              local dapui = require("dapui")

              function setup()
                dapui.setup({})
              end
              setup()

              vim.keymap.set("n", "<leader>cdd", dapui.toggle)
              vim.keymap.set("n", "<leader>cdr", setup)

              dap.listeners.before.attach.dapui_config = function()
                dapui.open()
              end
              dap.listeners.before.launch.dapui_config = function()
                dapui.open()
              end
              dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
              end
              dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
              end
            '';
        }
      ]
      ++ (optionals "go" [
        {
          plugin = nvim-dap-go;
          type = "lua";
          config =
            /*
            lua
            */
            ''
              require('dap-go').setup({})
            '';
        }
      ]);
  };
}
