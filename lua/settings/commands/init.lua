require("settings.commands.mode-error")
require("settings.commands.mode-git")

local userCommand = vim.api.nvim_create_user_command
local autoCommand = vim.api.nvim_create_autocmd

local diagnostic_utils = require("utils.diagnostic")

userCommand('LspErrorsQuickfix', diagnostic_utils.ShowLspDiagnosticsInQuickfix, {})
userCommand("LspErrorTelescope", diagnostic_utils.show_error_files, {})

autoCommand("TermOpen", {
  callback = function()
    vim.cmd [[ startinsert ]]
  end,
})

vim.cmd [[
highlight Normal ctermbg=NONE guibg=NONE
]]

vim.cmd [[
command! -nargs=* T split | wincmd j | resize 10 | terminal <args>
]]
