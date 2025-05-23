vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false

vim.opt.colorcolumn = "80,120"

vim.keymap.set("n", "gm", function()
  local bufferNumber = vim.fn.bufnr()
  local node = vim.treesitter.get_node({
    bufnr = bufferNumber,
  })

  if node == nil then
    return
  end
  if node:type() ~= "type_identifier" then
    print("Can only jump to methods on type identifiers.")
    return
  end

  local typeName = vim.treesitter.get_node_text(node, bufferNumber)

  local telescope = require("telescope.builtin")
  -- TODO: Telescope might not be installed. This needs
  -- to be restructured so that we can only add the mapping
  -- when telescope is enabled.
  telescope.grep_string({
    search = "func \\((.*[* ])?" .. typeName .. "\\)",
    use_regex = true,
  })
end, {
  desc = "Go to methods on type (for the language Go)",
  buffer = true,
})
