vim.g.mapleader = " "

-- Move between windows
vim.keymap.set("n", "<S-A-Left>", "<C-w><Left>")
vim.keymap.set("n", "<S-A-Right>", "<C-w><Right>")
vim.keymap.set("n", "<S-A-Up>", "<C-w><Up>")
vim.keymap.set("n", "<S-A-Down>", "<C-w><Down>")

-- Move through history
vim.keymap.set("n", "<A-Left>", "<C-O>")
vim.keymap.set("n", "<A-Right>", "<C-I>")

-- Clear search highlight
vim.keymap.set("n", "<leader>/", ":nohlsearch<cr>")
