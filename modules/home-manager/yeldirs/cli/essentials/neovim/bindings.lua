vim.g.mapleader = " "

-- Move between windows
vim.keymap.set("n", "<C-Left>", "<C-w><Left>", { desc = "Move focus to the window to the left" })
vim.keymap.set("n", "<C-Right>", "<C-w><Right>", { desc = "Move focus to the window to the right" })
vim.keymap.set("n", "<C-Up>", "<C-w><Up>", { desc = "Move focus to the window at the top" })
vim.keymap.set("n", "<C-Down>", "<C-w><Down>", { desc = "Move focus to the window at the bottom" })

-- Move through navigation history
vim.keymap.set("n", "<M-Left>", "<C-O>", { desc = "History back" })
vim.keymap.set("n", "<M-Right>", "<C-I>", { desc = "History forward" })

-- Misc
vim.keymap.set("n", "<leader>/", ":nohlsearch<cr>", { desc = "Clear search highlight" })

-- Insert line without entering insert mode
vim.keymap.set("n", "<M-o>", "o<Esc>", { desc = "Insert line below without entering insert mode" })
vim.keymap.set("n", "<M-O>", "O<Esc>", { desc = "Insert line above without entering insert mode" })

-- Programming
-- LSP
vim.keymap.set("n", "<leader>clr", "<cmd>LspRestart<cr>", { desc = "Restart current LSP" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Ask LSP to format the current buffer" })
vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "Show short documentation in floating window" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Pick code action" })
vim.keymap.set("i", "<C-Space>", function()
    require("cmp").complete()
end, { desc = "Trigger completion suggestions request" })
--   refactoring
vim.keymap.set("n", "<leader>crr", vim.lsp.buf.rename, { desc = "Ask LSP to rename symbol under cursor" })

--   navigation
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
--   diagnostics
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
