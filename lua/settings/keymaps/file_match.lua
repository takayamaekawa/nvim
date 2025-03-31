vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.keymap.set('n', '<leader>sr', function()
      vim.cmd('source %')
      vim.notify("Current file source is reloaded.", "info")
    end, { desc = 'Source current Lua file' })
  end,
})
