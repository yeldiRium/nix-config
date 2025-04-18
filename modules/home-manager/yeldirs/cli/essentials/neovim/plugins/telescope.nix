{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.telescope;

  neovimCfg = config.yeldirs.cli.essentials.neovim;
in {
  options = {
    yeldirs.cli.essentials.neovim.telescope.enable = lib.mkEnableOption "neovim plugin telescope";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      telescope-ui-select-nvim
      {
        plugin = telescope-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("telescope").setup({
              extensions = {
                ["ui-select"] = {
                  require("telescope.themes").get_dropdown({})
                },
              },
            })

            require("telescope").load_extension("ui-select")

            local telescope = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Search files in pwd" })
            vim.keymap.set("n", "<C-o>", telescope.git_files, { desc = "Search files in current git project" })
            vim.keymap.set("n", "<leader>fs", function()
              telescope.grep_string({
                search = vim.fn.input("Grep > "),
                use_regex = true,
                additional_args = { "--hidden", "--multiline" },
              })
            end, { desc = "Grep pwd using telescope" })

            vim.keymap.set("n", "<leader>fm", telescope.marks, { desc = "Show marks" })
            vim.keymap.set("n", "<leader>fr", telescope.registers, { desc = "Show register contents" })
            vim.keymap.set("n", "<leader>fq", telescope.quickfix, { desc = "Show quickfixes" })
            vim.keymap.set("n", "<leader>fd", telescope.diagnostics, { desc = "Show diagnosics" })

            -- replaces the bindings for lsp related actions from ../bindings.lua
            ${
              if neovimCfg.lsp.enable
              then
                /*
                lua
                */
                ''
            vim.keymap.set("n", "gd", telescope.lsp_definitions, { desc = "Go to definition" })
            vim.keymap.set("n", "gi", telescope.lsp_implementations, { desc = "Go to implementation" })
            vim.keymap.set("n", "gr", telescope.lsp_references, { desc = "Show references" })
            vim.keymap.set("n", "gt", telescope.lsp_type_definitions, { desc = "Go to type definition" })
                ''
              else ""
            }


            --- Taken from https://github.com/jemag/telescope-diff.nvim/blob/master/lua/telescope/_extensions/diff.lua
            local action_state = require("telescope.actions.state")
            local actions = require("telescope.actions")

            local function split_files(first_file, second_file)
              vim.cmd.tabnew(first_file)
              vim.cmd("vertical diffsplit " .. second_file)
              vim.cmd.normal({ args = { "gg" }, bang = true })
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
            end

            local function diff_current(opts)
              opts = opts or {}
              local local_opts = {
                prompt_title = "Pick file to compare",
                attach_mappings = function(_, map)
                  map("i", "<CR>", function(prompt_bufnr)
                    actions.close(prompt_bufnr)
                    local current_filepath = vim.fn.expand(vim.api.nvim_buf_get_name(opts.bufnr))
                    local selection = action_state.get_selected_entry()
                    split_files(current_filepath, selection.path)
                  end)
                  return true
                end,
              }
              opts = vim.tbl_extend("force", opts, local_opts)
              telescope.find_files(opts)
            end
            vim.keymap.set("n", "<C-d>", diff_current, { desc = "Show register contents using telescope" })
          '';
      }
    ];
  };
}
