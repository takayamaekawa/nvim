local M = {}

local nvim_shell, shell_args
if vim.fn.has('win32') == 1 then
  nvim_shell = 'pwsh'
  shell_args = { '-NoLogo' }
else
  nvim_shell = vim.o.shell
  shell_args = {}
end

M.float_terminal = require('toggleterm.terminal').Terminal:new({
  cmd = nvim_shell .. (shell_args[1] and (" " .. shell_args[1]) or ""),
  direction = "float"
})

require('toggleterm').setup({
  size = 100,
  open_mapping = [[<c-t>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  persist_mode = true,
  direction = 'float',
  close_on_exit = true,
})

function M.toggle_float_terminal()
  M.float_terminal:toggle()
end

return M
