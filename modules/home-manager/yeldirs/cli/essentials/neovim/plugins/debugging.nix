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
    yeldirs.cli.essentials.neovim.debugging.dynamicGoConfig = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "absolute path to a lua file that is executed when <leader>cdl is run to reload debugger configs. make sure that it's idempotent.";
    };
  };
  config = lib.mkIf cfg.enable {
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
              vim.fn.sign_define("DapStopped", { text = "▶", texthl = "", linehl = "", numhl = ""})

              vim.keymap.set("n", "<leader>cdb", dap.toggle_breakpoint, { desc = "Set debugger breakpoint" })
              vim.keymap.set("n", "<leader>cdc", dap.continue, { desc = "Start/continue debugger" })
              vim.keymap.set("n", "<leader>cdC", dap.terminate, { desc = "Terminate debugger session" })

              vim.keymap.set("n", "<leader>cdo", dap.step_over, { desc = "Step over statement" })
              vim.keymap.set("n", "<leader>cdi", dap.step_into, { desc = "Step into function" })
              vim.keymap.set("n", "<leader>cdx", dap.step_out, { desc = "Step out of function" })

              local dynamicDebuggerHooks = {}
              vim.keymap.set("n", "<leader>cdl", function()
                for i = 1, #dynamicDebuggerHooks, 1 do
                  dynamicDebuggerHooks[i]()
                end
              end, { desc = "Reload debugger configurations." })
            ''
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

              vim.keymap.set("n", "<leader>cdd", dapui.toggle, { desc = "Toggle debugger UI" })
              vim.keymap.set("n", "<leader>cdr", setup, { desc = "Load debugger UI settings (resets layout)" })

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
              local function reloadGoDebuggerConfigurations()
                require("dap").configurations.go = {}
                require("dap-go").setup({
                  delve = {
                    initialize_timeout_sec = 60,
                  },
                })

                ${if cfg.dynamicGoConfig != "" then "dofile(\"" + cfg.dynamicGoConfig + "\")" else ""}
              end
              dynamicDebuggerHooks[#dynamicDebuggerHooks + 1] = reloadGoDebuggerConfigurations
              reloadGoDebuggerConfigurations()
            '';
        }
      ]);
  };
}
