local workspace_picker = require('impl.workspacePicker')

local command = vim.api.nvim_create_user_command

command('WorkspacePicker', workspace_picker.show_workspaces, {})
