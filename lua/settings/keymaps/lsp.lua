-- local map = vim.api.nvim_set_keymap
local fmap = vim.keymap.set
local opts = { noremap = true, silent = true }

local diagnostics = require("settings.diagnostics")

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

fmap("n", "<leader>ce", diagnostics.show_error_files, opts)
fmap("n", "<leader>cw", diagnostics.show_current_error_files, opts)
