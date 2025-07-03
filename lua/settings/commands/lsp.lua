local userCommand = vim.api.nvim_create_user_command

local diagnostic_utils = require("utils.diagnostic")

userCommand('LspErrorsQuickfix', diagnostic_utils.ShowLspDiagnosticsInQuickfix, {})
userCommand("LspErrorTelescope", diagnostic_utils.show_error_files, {})
