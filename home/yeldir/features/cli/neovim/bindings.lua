vim.g.mapleader = " "

-- Move through history
vim.keymap.set("n", "<A-Left>", "<C-O>")
vim.keymap.set("n", "<A-Right>", "<C-I>")

-- Clear search highlight
vim.keymap.set("n", "<leader>/", ":nohlsearch<cr>")
