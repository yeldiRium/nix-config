require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({})
    },
  },
})

require("telescope").load_extension("ui-select")
require("telescope").load_extension("fzf")

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Search files in pwd" })
vim.keymap.set("n", "<C-o>", telescope.git_files, { desc = "Search files in current git project" })
vim.keymap.set("n", "<leader>fs", function()
  telescope.grep_string({
    search = vim.fn.input("Grep > "),
    use_regex = true,
    additional_args = { "--hidden", "--multiline", "--iglob", "!.git" },
  })
end, { desc = "Grep pwd using telescope" })
vim.keymap.set("n", "<leader>fS", function()
  local bufferDirectory = vim.fn.expand("%:p:h")
  telescope.grep_string({
    search = vim.fn.input("Grep bufferdir > "),
    use_regex = true,
    additional_args = { "--hidden", "--multiline", "--iglob", "!.git" },
    search_dirs = {
      bufferDirectory,
    },
  })
end, { desc = "Grep directory of open buffer using telescope" })

vim.keymap.set("n", "<leader>fm", telescope.marks, { desc = "Show marks" })
vim.keymap.set("n", "<leader>fr", telescope.registers, { desc = "Show register contents" })
vim.keymap.set("n", "<leader>fq", telescope.quickfix, { desc = "Show quickfixes" })
vim.keymap.set("n", "<leader>fd", telescope.diagnostics, { desc = "Show diagnostics" })
vim.keymap.set("n", "<leader>fn", telescope.jumplist, { desc = "Show jumplist" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Show help" })
