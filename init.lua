require("config.lazy")
require("config.autocmds")
require("settings")

require('bufferline').setup({})

require("settings.keymaps")
-- require("ibl").setup({
--   indent = {
--     char = "|",
--   },
-- })
require("settings.conform")

-- read debug.lua if it exists
if vim.loop.fs_stat(vim.fn.stdpath('config') .. '/lua/debug.lua') then
  dofile(vim.fn.stdpath('config') .. '/lua/debug.lua')
end

-- Python3 provider の設定（config.jsonから読み取る）
local configHandler = require("configHandler")
local config = configHandler.get

if config and config.self and config.self.python_environments and config.self.active_python_env then
  local active_env_name = config.self.active_python_env
  local python_path = nil
  
  -- active_python_envに一致する環境を探す
  for _, env in ipairs(config.self.python_environments) do
    if env.name == active_env_name then
      python_path = env.path
      break
    end
  end
  
  if python_path then
    vim.g.python3_host_prog = python_path
  else
    vim.notify("Active Python environment '" .. active_env_name .. "' not found in config.json", vim.log.levels.ERROR)
    -- フォールバック
    vim.g.python3_host_prog = vim.fn.expand("$HOME") .. "/anaconda3/bin/python"
  end
else
  -- フォールバック: config.jsonに設定がない場合はデフォルト値を使用
  vim.g.python3_host_prog = vim.fn.expand("$HOME") .. "/anaconda3/bin/python"
  vim.notify("Python environments not configured in config.json, using default", vim.log.levels.WARN)
end

-- Example for configuring Neovim to load user-installed installed Lua rocks:
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
