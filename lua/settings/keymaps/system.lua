local map = vim.api.nvim_set_keymap
local fmap = vim.keymap.set
local opts = { noremap = true, silent = true }

local current_time = os.date('%Y-%m-%d %H:%M:%S')

-- system command
map('n', '<leader>fo', ':!dolphin --select %<CR>', opts)

-- utility
map('i', 'jj', '<Esc>', opts)
map('n', '<F2>', ':if &mouse == "" | set mouse=a | echo "Mouse: ON" | else | set mouse= | echo "Mouse: OFF" | endif<CR>',
  opts)
map("n", "<leader>qq", ":qall<CR>", opts)
map("t", "<C-\\><C-q><C-q>", ":qall<CR>", opts)

-- file operation
-- save all file
map("n", "<leader>wa", ":wall<CR>", opts)
-- clip the file name
fmap('n', '<Leader>fn', function()
  vim.fn.setreg('+', vim.fn.expand('%:t'))
  vim.notify("Copied the current file name. (" .. vim.fn.expand('%:t') .. ")", "info")
end, opts)
-- clip the relative file path
fmap('n', '<Leader>fpr', function()
  vim.fn.setreg('+', vim.fn.expand('%:p:.'))
  vim.notify("Copied the current file's relative path. (" .. vim.fn.expand('%:p:.') .. ")", "info")
end, opts)
-- clip the absolute file path
fmap('n', '<Leader>fpa', function()
  vim.fn.setreg('+', vim.fn.expand('%:p'))
  vim.notify("Copied the current file's absolute path. (" .. vim.fn.expand('%:p') .. ")", "info")
end, opts)
-- clip the file content
fmap('n', '<Leader>fc', function()
  local lines = vim.fn.readfile(vim.fn.expand('%:p'))
  vim.fn.setreg('+', table.concat(lines, "\n"))
  vim.notify("Copied the current file's content. (" .. current_time .. ")", "info")
end, opts)
-- clip the relative file path and the file content
fmap('n', '<Leader>fy', function()
  local lines = vim.fn.readfile(vim.fn.expand('%:p'))
  vim.fn.setreg('+', vim.fn.expand('%:p:.') .. '\n' .. table.concat(lines, "\n"))
  vim.notify("Copied the current file's relative path and content. (" .. current_time .. ")", "info")
end, opts)

-- terminal
-- open by default nvim's one
map('n', '<leader>ts', '<Cmd>terminal<CR>', opts);
