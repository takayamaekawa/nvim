require("conform").setup({
  log_level = vim.log.levels.DEBUG,
  formatters = {
    php_cs_fixer = {
      command = "/home/bella/git/bbs/vendor/bin/php-cs-fixer",
      -- args = { "fix", "--config=.php-cs-fixer.dist.php", "--using-cache=no" },
      args = { "fix", "$FILENAME", "--config=.php-cs-fixer.dist.php", "--using-cache=no" },
    },
  },
  formatters_by_ft = {
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    php = { "php_cs_fixer" },
  },
  format_on_save = function(bufnr)
    local ignore_filetypes = { "ejs", "html" }
    local ignore_by_external_filetypes = { "php" }

    if vim.tbl_contains(ignore_by_external_filetypes, vim.bo[bufnr].filetype) then
      return { timeout_ms = 2000 } -- 例: 2秒 (2000ミリ秒) に増やす。必要に応じてさらに増やす。
    end

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

    -- その他のファイルタイプはlsp_formatにフォールバック
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
})
