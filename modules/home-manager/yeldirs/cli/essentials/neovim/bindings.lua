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

-- Scrolling
vim.keymap.set({"n", "v"}, "<S-Up>", "<C-Y>", { desc = "Scroll up, don't move cursor" })
vim.keymap.set({"n", "v"}, "<M-Up>", function()
  local height = vim.api.nvim_win_get_height(0)
  local scroll = math.floor(height / 2)
  vim.cmd("normal! "..scroll.."<C-Y>")
end, { desc = "Scroll half screen up, don't move cursor" })
vim.keymap.set({"n", "v"}, "<S-Down>", "<C-E>", { desc = "Scroll down" })
vim.keymap.set({"n", "v"}, "<M-Down>", function()
  local height = vim.api.nvim_win_get_height(0)
  local scroll = math.floor(height / 2)
  vim.cmd("normal! "..scroll.."<C-E>")
end, { desc = "Scroll half screen down, don't move cursor" })
vim.keymap.set({"n", "v"}, "<S-Left>", "zh", { desc = "Scroll left" })
vim.keymap.set({"n", "v"}, "<S-Right>", "zl", { desc = "Scroll right" })

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
vim.keymap.set("n", "grf", vim.lsp.buf.format, { desc = "Ask LSP to format the current buffer" })
vim.keymap.set("n", "K", function() -- This overrides a default binding
  vim.lsp.buf.hover({
    border = "rounded",
  })
end, { desc = "Show short documentation in floating window" })
vim.keymap.set("i", "<C-Space>", function()
  require("cmp").complete()
end, { desc = "Trigger completion suggestions request" })
--   navigation
vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "Go to definition" })
--   diagnostics
vim.keymap.set("n", "<leader>chd", vim.diagnostic.open_float, { desc = "Floating diagnostic" })

-- Git
vim.keymap.set("n", "<leader>go", function()
  local filePath = vim.fn.expand("%:p")
  vim.cmd("!open-git-file " .. filePath)
end, { desc = "If the open file belongs to a git repository with a remote, open the file in the remote's GUI" })

-- Diff
vim.keymap.set("n", "<leader>dt", function()
  vim.cmd("difft")
end, { desc = "Add current buffer to diff" })
vim.keymap.set("n", "<leader>do", function()
  vim.cmd("diffo!")
end, { desc = "Remove all buffers from diff" })
