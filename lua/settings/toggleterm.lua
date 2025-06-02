local M = {}

local nvim_shell = vim.o.shell

M.float_terminal = require('toggleterm.terminal').Terminal:new({ cmd = nvim_shell, direction = "float" })

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

vim.keymap.set("n", "<c-t>", M.toggle_float_terminal)

return M
