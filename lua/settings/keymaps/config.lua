local map = vim.api.nvim_set_keymap

local configHandler = require("configHandler")
local config, configpath = configHandler.get, configHandler.getpath

-- debug mode toggle
map('n', '<leader>dd', '', {
  noremap = true,
  silent = true,
  callback = function()
    if config and config.self and config.self.debug ~= nil then
      config.self.debug = not config.self.debug
      local success = configHandler.update(config)
      if not success then
        vim.notify("Failed to update configuration file: " .. configpath, vim.log.levels.ERROR)
        return
      end

      vim.notify("Debug mode is now " .. (config.self.debug and "enabled" or "disabled"), vim.log.levels.INFO)
    else
      vim.notify("Debug mode is not configured.", vim.log.levels.INFO)
    end
  end,
})

-- reload debug.lua
map('n', '<leader>dr', '', {
  noremap = true,
  silent = true,
  callback = function()
    local debug_file = vim.fn.stdpath('config') .. '/lua/debug.lua'
    if vim.loop.fs_stat(debug_file) then
      dofile(debug_file)
      vim.notify("Debug configuration reloaded.", vim.log.levels.INFO)
    else
      vim.notify("No debug.lua file found.", vim.log.levels.ERROR)
    end
  end,
})
