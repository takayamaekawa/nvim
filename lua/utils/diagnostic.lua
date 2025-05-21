local M = {}

local telescope = require("telescope.builtin")

local function get_all_error_files(callback)
  local error_files = {}
  local workspace_folders = vim.lsp.buf.list_workspace_folders()

  if #workspace_folders == 0 then
    table.insert(workspace_folders, vim.loop.cwd())
  end

  local files = {}
  for _, folder in ipairs(workspace_folders) do
    local result = vim.fn.systemlist("rg --files " .. vim.fn.shellescape(folder))
    vim.list_extend(files, result)
  end

  local total_files = #files
  if total_files == 0 then
    callback({})
    return
  end

  local processed = 0

  for _, file in ipairs(files) do
    local bufnr = vim.fn.bufadd(file) -- バッファに追加
    vim.fn.bufload(bufnr)             -- バッファをロードして LSP に診断させる
  end

  -- **LSP の診断を定期的にチェックする**
  local check_diagnostics
  local max_wait = 2000 -- 最大5秒待機
  local start_time = vim.loop.now()

  check_diagnostics = vim.schedule_wrap(function()
    for _, file in ipairs(files) do
      local bufnr = vim.fn.bufadd(file)
      local diagnostics = vim.diagnostic.get(bufnr)
      for _, d in ipairs(diagnostics) do
        if d.severity == vim.diagnostic.severity.ERROR then
          error_files[file] = true
          break
        end
      end
    end

    processed = processed + 1

    -- 診断が全ファイル分取得できた or 最大時間を超えたら終了
    if processed >= total_files or (vim.loop.now() - start_time) > max_wait then
      callback(vim.tbl_keys(error_files))
    else
      vim.defer_fn(check_diagnostics, 200) -- 200ms 後に再チェック
    end
  end)

  check_diagnostics() -- 診断チェックを開始
end

local function get_current_error_files()
  local error_files = {}
  local buffers = vim.api.nvim_list_bufs()

  for _, bufnr in ipairs(buffers) do
    local diagnostics = vim.diagnostic.get(bufnr)
    for _, d in ipairs(diagnostics) do
      if d.severity == vim.diagnostic.severity.ERROR then
        local file = vim.fn.bufname(bufnr)
        if file ~= "" then -- ファイル名が取得できる場合のみ
          error_files[file] = true
        end
        break
      end
    end
  end

  return vim.tbl_keys(error_files)
end

function M.show_error_files()
  print("診断を取得中...")
  get_all_error_files(function(error_files)
    if #error_files == 0 then
      print("エラーのあるファイルはありません。")
      return
    end

    print("診断完了。Telescope を開きます。")
    telescope.find_files({
      prompt_title = "Error Files",
      cwd = vim.loop.cwd(),
      find_command = { "echo", table.concat(error_files, "\n") }
    })
  end)
end

-- 既存のエラーを表示する関数
function M.show_current_error_files()
  local error_files = get_current_error_files()

  if #error_files == 0 then
    print("エラーのあるファイルはありません。")
    return
  end

  print("既存のエラーを検出しました。Telescope を開きます。")
  telescope.find_files({
    prompt_title = "Current Error Files",
    cwd = vim.loop.cwd(),
    find_command = { "echo", table.concat(error_files, "\n") }
  })
end

-- QuickfixウィンドウにLSPエラーを表示する関数
function M.ShowLspDiagnosticsInQuickfix()
  vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
end

-- 重要度レベルを文字列に変換するヘルパー関数
local function get_severity_name(level)
  if level == vim.diagnostic.severity.ERROR then
    return "ERROR"
  elseif level == vim.diagnostic.severity.WARN then
    return "WARN"
  elseif level == vim.diagnostic.severity.INFO then
    return "INFO"
  elseif level == vim.diagnostic.severity.HINT then
    return "HINT"
  else
    return "UNKNOWN"
  end
end

-- 診断メッセージを整形してクリップボードにコピーする汎用関数
function M.copy_diagnostics_to_clipboard(severity_level, prefix_severity)
  -- severity_level が nil の場合、すべての診断を取得
  local diagnostics = vim.diagnostic.get(0, severity_level and { severity = severity_level } or nil)

  local severity_display_name = ""
  if severity_level then
    severity_display_name = get_severity_name(severity_level):lower() .. " "
  else
    severity_display_name = "diagnostics "
  end

  if vim.tbl_isempty(diagnostics) then
    print("No LSP " .. severity_display_name .. "found")
    return
  end

  local messages = {}
  for _, diag in ipairs(diagnostics) do
    local message_prefix = ""
    if prefix_severity then
      message_prefix = string.format("[%s] ", get_severity_name(diag.severity))
    end
    table.insert(messages, string.format("%s%s:%d:%d: %s",
      message_prefix,
      vim.api.nvim_buf_get_name(0), diag.lnum + 1, diag.col + 1, diag.message))
  end

  local diagnostic_text = table.concat(messages, "\n")
  vim.fn.setreg("+", diagnostic_text)
  print("LSP " .. severity_display_name .. "copied to clipboard")
end

return M
