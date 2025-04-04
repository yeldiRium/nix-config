vim.g.mapleader = " "

-- Move between windows
vim.keymap.set("n", "<C-Left>", "<C-w><Left>")
vim.keymap.set("n", "<C-Right>", "<C-w><Right>")
vim.keymap.set("n", "<C-Up>", "<C-w><Up>")
vim.keymap.set("n", "<C-Down>", "<C-w><Down>")

-- Move through navigation history
vim.keymap.set("n", "<M-Left>", "<C-O>")
vim.keymap.set("n", "<M-Right>", "<C-I>")

-- Clear search highlight
vim.keymap.set("n", "<leader>/", ":nohlsearch<cr>")

-- Insert line without entering insert mode
vim.keymap.set("n", "<M-o>", "o<Esc>")
vim.keymap.set("n", "<M-O>", "O<Esc>")

-- Programming
-- LSP
vim.keymap.set("n", "<leader>clr", "<cmd>LspRestart<cr>")
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("i", "<C-Space>", function()
    require("cmp").complete()
end, { desc = "Trigger completion suggestions request" })
--   refactoring
vim.keymap.set("n", "<leader>crr", vim.lsp.buf.rename, { desc = "Rename symbol" })

--   navigation
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
--   diagnostics
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
