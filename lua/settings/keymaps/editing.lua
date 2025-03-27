local map = vim.api.nvim_set_keymap
local fmap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- [s]elect [a]ll area by visual mode
map('n', '<S-a>', 'ggVG', opts)

-- indent
map('n', '<S-f>', 'gg=G', opts) -- [i]ndent [f]ile
map('n', '<S-w>', ':w<CR>', opts)
fmap('n', 'O', function()
  local current_line = vim.fn.line('.')
  vim.api.nvim_command(current_line .. 'put =' .. 'repeat(nr2char(10), 1)')
  vim.api.nvim_win_set_cursor(0, { current_line + 1, 0 })
end, opts)
-- by tab
map('v', '<Tab>', '>gv', opts)
map('v', '<S-Tab>', '<gv', opts)
map('n', '<Tab>', '>>', opts)
map('n', '<S-Tab>', '<<', opts)
map('i', '<Tab>', '<C-t>', opts)
map('i', '<S-Tab>', '<C-d>', opts)

-- search
-- delete highlight
map("n", "<leader>hh", '<Cmd>nohlsearch<CR>', opts)

-- tab size
local function set_tabstop(tabstop)
  -- vim.opt.tabstop = tabstop
  vim.opt.shiftwidth = tabstop
  -- vim.opt.expandtab = false
  vim.notify("Set tab size to " .. tabstop, "info")
end

for i = 1, 8 do
  fmap("n", "<leader>t" .. i, function()
    set_tabstop(i)
  end, opts)
end
