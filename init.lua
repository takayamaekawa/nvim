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

-- Python3 provider の設定
vim.g.python3_host_prog = vim.fn.expand("$HOME") .. "/anaconda3/bin/python"

-- Example for configuring Neovim to load user-installed installed Lua rocks:
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
