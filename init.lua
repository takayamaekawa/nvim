require("config.lazy")
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
