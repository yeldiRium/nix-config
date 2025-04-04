vim.api.nvim_create_augroup(
  "RestoreCursorPosition",
  {
    clear = true,
  }
)
vim.api.nvim_create_autocmd(
  {
    "BufReadPost",
  },
  {
    group = "RestoreCursorPosition",
    callback = function()
      local lastLine = vim.fn.line("'\"")
      if lastLine <= 1 then
        return
      end
      if lastLine >= vim.fn.line("$") then
        return
      end

      vim.cmd("normal! g`\"")
    end,
  }
)
