{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli.essentials.neovim) supportedLanguages;
  cfg = config.yeldirs.cli.essentials.neovim.debugging;

  isLanguageSupported = language: lib.elem language supportedLanguages;
  forLanguage = language: list: lib.optionals (isLanguageSupported language) list;
in
{
  options = {
    yeldirs.cli.essentials.neovim.debugging.enable = lib.mkEnableOption "neovim debugging support";
    yeldirs.cli.essentials.neovim.debugging.dynamicGoConfig = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        absolute path to a lua file that is executed when <leader>cdl is run to reload debugger configs. make sure that it's idempotent.
        example:
        ```
        local dap = require("dap")

        dap.configurations.go[#dap.configurations.go + 1] = {
          type = "go",
          name = "e2e: Debug DocDB",
          request = "launch",
          program = "''${fileDirname}",
          args = { "-v", "-timeout", "36000s", "-run", "TestDocumentDB" },
          buildFlags = "",
          outputMode = "remote",
        }
        ```
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # DAP servers
    home.packages =
      with pkgs;
      (forLanguage "go" [
        unstable.delve
      ]);

    home.sessionVariables = lib.mkIf (isLanguageSupported "go") {
      # This is necessary to make delve work. Some weird CGO/gcc bullshit.
      NIX_HARDENING_ENABLE = "";
    };
    programs.neovim.plugins =
      with pkgs.unstable.vimPlugins;
      [
        # dependencies
        nvim-nio

        {
          plugin = nvim-dap;
          type = "lua";
          config = lib.concatLines [
            # lua
            ''
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
          plugin = debugmaster-nvim;
          type = "lua";
          config =
            # lua
            ''
              local dm = require("debugmaster")

              vim.keymap.set({ "n", "v" }, "<leader>cdd", dm.mode.toggle, { nowait = true })
            '';
        }
      ]
      ++ (forLanguage "go" [
        {
          plugin = nvim-dap-go;
          type = "lua";
          config =
            # lua
            ''
              local function reloadGoDebuggerConfigurations()
                local dapGo = require("dap-go")
                require("dap").configurations.go = {
                  {
                    type = "go",
                    name = "Debug Package (Arguments)",
                    request = "launch",
                    program = "''${fileDirname}",
                    args = dapGo.get_arguments,
                    buildFlags = "",
                    outputMode = "remote",
                  },
                }

                ${if cfg.dynamicGoConfig != "" then "dofile(\"" + cfg.dynamicGoConfig + "\")" else ""}

                dapGo.setup({
                  delve = {
                    initialize_timeout_sec = 60,
                  },
                })
              end
              dynamicDebuggerHooks[#dynamicDebuggerHooks + 1] = reloadGoDebuggerConfigurations
              reloadGoDebuggerConfigurations()
            '';
        }
      ]);
  };
}
