vim.g.mapleader = " "

-- keymap groups
vim.keymap.set("n", "<leader>c", "<Nop>", { desc = "Code" })
vim.keymap.set("n", "<leader>cd", "<Nop>", { desc = "Debugger" })
vim.keymap.set("n", "<leader>ch", "<Nop>", { desc = "Hover" })
vim.keymap.set("n", "<leader>cl", "<Nop>", { desc = "LSP" })
vim.keymap.set("n", "<leader>cr", "<Nop>", { desc = "Refactoring" })
vim.keymap.set("n", "<leader>ct", "<Nop>", { desc = "Testing" })
vim.keymap.set("n", "<leader>f", "<Nop>", { desc = "Pickers/Browsers" })
vim.keymap.set("n", "<leader>g", "<Nop>", { desc = "Git" })
vim.keymap.set("n", "<leader>h", "<Nop>", { desc = "Harpoon" })

-- Move between windows
vim.keymap.set("n", "<C-Left>", "<C-w><Left>", { desc = "Move focus to the window to the left" })
vim.keymap.set("n", "<C-Right>", "<C-w><Right>", { desc = "Move focus to the window to the right" })
vim.keymap.set("n", "<C-Up>", "<C-w><Up>", { desc = "Move focus to the window at the top" })
vim.keymap.set("n", "<C-Down>", "<C-w><Down>", { desc = "Move focus to the window at the bottom" })

-- Move between tabs
vim.keymap.set("n", "{", "gT", { desc = "Previous tab" })
vim.keymap.set("n", "}", "gt", { desc = "Next tab" })
vim.keymap.set("n", "(", function() vim.cmd("-tabmove") end, { desc = "Move tab left" })
vim.keymap.set("n", ")", function() vim.cmd("+tabmove") end, { desc = "Move tab right" })

-- Move through navigation history
vim.keymap.set("n", "<M-Left>", "<C-O>", { desc = "History back" })
vim.keymap.set("n", "<M-Right>", "<C-I>", { desc = "History forward" })

-- Misc
vim.keymap.set("n", "<leader>/", ":nohlsearch<cr>", { desc = "Clear search highlight" })

-- Layout
vim.keymap.set("n", "<leader>lw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle linewrap" })

-- Insert line without entering insert mode
vim.keymap.set("n", "<M-o>", "o<Esc>", { desc = "Insert line below without entering insert mode" })
vim.keymap.set("n", "<M-O>", "O<Esc>", { desc = "Insert line above without entering insert mode" })

-- Programming
-- LSP
vim.keymap.set("n", "<leader>clr", "<cmd>LspRestart<cr>", { desc = "Restart current LSP" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Ask LSP to format the current buffer" })
vim.keymap.set("n", "<leader>chh", function()
  vim.lsp.buf.hover({
    border = "rounded",
  })
end, { desc = "Show short documentation in floating window" })
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
vim.keymap.set("n", "<leader>chd", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
