vim.g.mapleader = " "

-- Move between windows
vim.keymap.set("n", "<S-A-Left>", "<C-w><Left>")
vim.keymap.set("n", "<S-A-Right>", "<C-w><Right>")
vim.keymap.set("n", "<S-A-Up>", "<C-w><Up>")
vim.keymap.set("n", "<S-A-Down>", "<C-w><Down>")

-- Move through navigation history
vim.keymap.set("n", "<A-Left>", "<C-O>")
vim.keymap.set("n", "<A-Right>", "<C-I>")

-- Clear search highlight
vim.keymap.set("n", "<leader>/", ":nohlsearch<cr>")

-- Programming
-- LSP
vim.keymap.set("n", "<leader>cr", "<cmd>LspRestart<cr>")
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
-- Movement
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
-- Diagnostics
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
vim.keymap.set("n", "gq", vim.diagnostic.setqflist, { desc = "Diagnostics on quickfix" })
