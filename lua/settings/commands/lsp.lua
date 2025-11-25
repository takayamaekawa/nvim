local userCommand = vim.api.nvim_create_user_command

local diagnostic_utils = require("utils.diagnostic")

userCommand('LspErrorsQuickfix', diagnostic_utils.ShowLspDiagnosticsInQuickfix, {})
userCommand("LspErrorTelescope", diagnostic_utils.show_error_files, {})

-- Pyright LSPを再起動するコマンド
local function restart_pyright()
  local clients = vim.lsp.get_clients({ name = "pyright" })
  
  if #clients == 0 then
    vim.notify("Pyright is not running", vim.log.levels.WARN)
    return
  end
  
  for _, client in ipairs(clients) do
    vim.notify("Stopping Pyright (PID: " .. client.pid .. ")...", vim.log.levels.INFO)
    client.stop()
  end
  
  -- LSPが完全に停止するまで待ってから再起動
  vim.defer_fn(function()
    vim.cmd("LspStart pyright")
    vim.notify("Pyright restarted", vim.log.levels.INFO)
  end, 1000)
end

userCommand('RestartPyright', restart_pyright, { desc = 'Restart Pyright LSP server' })

-- 全LSPサーバーを再起動するコマンド
local function restart_all_lsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  
  if #clients == 0 then
    vim.notify("No LSP clients running for this buffer", vim.log.levels.WARN)
    return
  end
  
  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
    vim.notify("Stopping " .. client.name .. " (PID: " .. client.pid .. ")...", vim.log.levels.INFO)
    client.stop()
  end
  
  -- LSPが完全に停止するまで待ってから再起動
  vim.defer_fn(function()
    for _, name in ipairs(client_names) do
      vim.cmd("LspStart " .. name)
    end
    vim.notify("All LSP servers restarted", vim.log.levels.INFO)
  end, 1000)
end

userCommand('RestartLsp', restart_all_lsp, { desc = 'Restart all LSP servers for current buffer' })

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
