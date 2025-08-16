local userCommand = vim.api.nvim_create_user_command

local diagnostic_utils = require("utils.diagnostic")

userCommand('LspErrorsQuickfix', diagnostic_utils.ShowLspDiagnosticsInQuickfix, {})
userCommand("LspErrorTelescope", diagnostic_utils.show_error_files, {})

local function format_all_java_files()
  local handle = io.popen("find . -name '*.java' -type f")
  if not handle then
    print("Failed to execute find command")
    return
  end

  local java_files = {}
  for file in handle:lines() do
    table.insert(java_files, file)
  end
  handle:close()

  if #java_files == 0 then
    print("No Java files found in current directory")
    return
  end

  print("Found " .. #java_files .. " Java files. Formatting...")

  for _, file in ipairs(java_files) do
    vim.cmd("edit " .. vim.fn.fnameescape(file))
    vim.lsp.buf.format({ timeout_ms = 5000 })
    vim.cmd("write")
    vim.cmd("bdelete")
    print("Formatted: " .. file)
  end

  print("Completed formatting " .. #java_files .. " Java files")
end

userCommand('FormatAllJava', format_all_java_files, { desc = 'Format all Java files in current directory' })
