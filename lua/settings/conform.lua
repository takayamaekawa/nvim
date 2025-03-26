require("conform").setup({
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

-- vim.api.nvim_create_autocmd("BufReadPost", {
--   pattern = "*",
--   callback = function()
--     require("conform").format({
--       lsp_fallback = true,
--       async = false,
--     })
--   end,
-- })

-- local excluded_filetypes = { "ejs" }

-- local function unpack(list)
--   local result = {}
--   for i, v in ipairs(list) do
--     result[v] = false
--   end
--   return result
-- end

-- require("conform").setup({
--   filetypes = unpack(excluded_filetypes),
--   formatters_by_ft = {
--     ejs = { "prettier" },
--   },
-- })

-- local format_if_not_excluded = function()
--   local current_filetype = vim.bo.filetype
--   for _, filetype in ipairs(excluded_filetypes) do
--     if current_filetype == filetype then
--       return
--     end
--   end
--   require("conform").format({
--     lsp_fallback = true,
--     async = false,
--   })
-- end

-- vim.api.nvim_create_autocmd("BufReadPost", {
--   pattern = "*",
--   callback = format_if_not_excluded,
-- })

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = format_if_not_excluded,
-- })
