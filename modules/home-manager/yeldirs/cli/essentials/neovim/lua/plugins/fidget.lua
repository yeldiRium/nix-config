return {
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        override_vim_notify = true,
      },
    },
    config = function(opts)
      require("fidget").setup(opts)
      vim.notify("base plugin fidget")
    end,
  },
}
