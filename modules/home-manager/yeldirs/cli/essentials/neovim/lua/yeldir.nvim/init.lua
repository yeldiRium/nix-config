vim.notify("before return")

local M = {}

--@param opts Table
function M.setup(opts)
  vim.notify("setup")
end

return M
