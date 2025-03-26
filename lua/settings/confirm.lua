require("conform").setup({
  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true,
    quiet = false,
  },
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    require("conform").format({
      lsp_fallback = true,
      async = false, -- trueにすると非同期フォーマット
    })
  end,
})
