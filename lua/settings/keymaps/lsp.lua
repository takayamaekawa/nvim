-- local M = {}

-- M.on_attach = function(client, bufnr)
-- local map = vim.api.nvim_set_keymap
local fmap = vim.keymap.set
local opts = { noremap = true, silent = true }

local diagnostic_utils = require("utils.diagnostic")

-- 各重要度レベルの診断をコピー
fmap("n", "<leader>fe",
  function() diagnostic_utils.copy_diagnostics_to_clipboard(vim.diagnostic.severity.ERROR, false) end, opts)
fmap("n", "<leader>fw",
  function() diagnostic_utils.copy_diagnostics_to_clipboard(vim.diagnostic.severity.WARN, false) end, opts)
fmap("n", "<leader>fi",
  function() diagnostic_utils.copy_diagnostics_to_clipboard(vim.diagnostic.severity.INFO, false) end, opts)
fmap("n", "<leader>fh",
  function() diagnostic_utils.copy_diagnostics_to_clipboard(vim.diagnostic.severity.HINT, false) end, opts)

-- すべての診断をコピー (重要度プレフィックス付き)
fmap("n", "<leader>fa", function()
  diagnostic_utils.copy_diagnostics_to_clipboard(nil, true)
end, opts)

-- these are added from nvim-metals: https://github.com/scalameta/nvim-metals/discussions/39
fmap("n", "<leader>cl", function() vim.lsp.codelens.run({}) end)
fmap("n", "<leader>sh", function() vim.lsp.buf.signature_help({}) end)
fmap("n", "<leader>rn", function() vim.lsp.buf.rename({}) end)
fmap("n", "<leader>fm", function() vim.lsp.buf.format({}) end)
-- fmap("n", "<leader>ca", vim.lsp.buf.code_action)
fmap('n', '<leader>co', function()
  vim.lsp.buf.code_action({
    -- context = { only = { 'source.organizeImports' } },
    -- apply = true,
  })
end)
-- map("n", "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
fmap("n", "gds", vim.lsp.buf.document_symbol, opts)
fmap("n", "gws", vim.lsp.buf.workspace_symbol, opts)
fmap("n", "<leader>ws", function()
  require("metals").hover_worksheet()
end, opts)
-- all workspace diagnostics
fmap("n", "<leader>aa", vim.diagnostic.setqflist, opts)
-- all workspace errors
fmap("n", "<leader>ae", function()
  vim.diagnostic.setqflist({ severity = "E" })
end, opts)
-- all workspace warnings
fmap("n", "<leader>aw", function()
  vim.diagnostic.setqflist({ severity = "W" })
end, opts)
-- buffer diagnostics only
fmap("n", "<leader>d", vim.diagnostic.setloclist, opts)
fmap("n", "[c", function()
  vim.diagnostic.goto_prev({ wrap = false })
end, opts)
fmap("n", "]c", function()
  vim.diagnostic.goto_next({ wrap = false })
end, opts)

-- jump definition
fmap("n", "gd", vim.lsp.buf.definition, opts)
-- jump type definition
fmap("n", "gD", vim.lsp.buf.type_definition, opts)
-- jump implemention
fmap("n", "gi", vim.lsp.buf.implementation, opts)
-- jump references
fmap("n", "gr", vim.lsp.buf.references, opts)

-- this is the same of C-K for cursor on that of variable
-- fmap("n", "<leader>h", vim.lsp.buf.hover, opts)

fmap("n", "<leader>ce", diagnostic_utils.show_error_files, opts)
fmap("n", "<leader>cw", diagnostic_utils.show_current_error_files, opts)
-- end

-- mode error
fmap('n', '<leader>me', '<cmd>ModeError<CR>', {
  noremap = true,
  silent = true,
  desc = '[M]ode [E]rror: Start diagnostic navigation',
})

-- LSP再起動
fmap('n', '<leader>lr', '<cmd>RestartLsp<CR>', {
  noremap = true,
  silent = true,
  desc = '[L]SP [R]estart: Restart all LSP servers',
})

-- Pyright再起動
fmap('n', '<leader>lp', '<cmd>RestartPyright<CR>', {
  noremap = true,
  silent = true,
  desc = '[L]SP [P]yright: Restart Pyright LSP server',
})

-- return M
