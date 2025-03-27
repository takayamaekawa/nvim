require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    sh = { "shfmt" },
    bash = { "shfmt" },
  },
  format_on_save = function(bufnr)
    local ignore_filetypes = { "ejs", "html" }
    if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      return
    end

    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname:match("/node_modules/") then
      return
    end

    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
})
