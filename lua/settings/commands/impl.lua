local workspace_picker = require('impl.workspacePicker')
local python_env_picker = require('impl.pythonEnvPicker')

local command = vim.api.nvim_create_user_command

command('WorkspacePicker', workspace_picker.show_workspaces, {})
command('PythonEnvPicker', python_env_picker.show_python_envs, { desc = 'Select Python environment' })
