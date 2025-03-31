vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.keymap.set('n', '<leader>nv', function()
      vim.cmd('source %')
      vim.notify("Current file is sourced.", "info")
    end, { desc = 'Source current Lua file' })
  end,
})
