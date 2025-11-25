---@types vim.lsp.Config
return {
  -- Node.jsのメモリ制限を増やす（デフォルト4GB → 8GB）
  cmd = { "pyright-langserver", "--stdio", "--node-ipc" },
  -- 環境変数でNode.jsヒープサイズを設定
  cmd_env = {
    NODE_OPTIONS = "--max-old-space-size=8192" -- 8GB
  },
  settings = {
    python = {
      formatting = {
        provider = "ruff",
        tabSize = 2,
      },
      analysis = {
        -- メモリ使用量を最適化
        diagnosticMode = "openFilesOnly",
        -- 型チェックを軽量化
        typeCheckingMode = "basic",
        -- ファイル変更の監視を改善
        autoSearchPaths = true,
        useLibraryCodeForTypes = false,
        -- notebookセルの分析を改善
        autoImportCompletions = true,
        -- 以下を追加してメモリ使用を削減
        exclude = {
          "**/__pycache__",
          "**/node_modules",
          "**/.venv",
          "**/venv",
          "**/.git",
          "**/site-packages",
        },
        -- インポート解決を軽量化
        indexing = true,
        -- 大規模ライブラリのスタブを無効化
        stubPath = "",
        -- 診断の範囲を制限
        logLevel = "Error",
        -- ファイル監視を制限
        watchPaths = {},
      }
    }
  },
  -- ファイル変更通知を最適化
  flags = {
    debounce_text_changes = 500, -- テキスト変更の通知を遅延（デフォルト150ms → 300ms）
  },
  -- Jupyterノートブック用の最適化
  on_new_config = function(new_config, new_root_dir)
    -- ipynbファイルの場合、特別な設定を適用
    if vim.bo.filetype == "python" and vim.fn.expand("%:e") == "ipynb" then
      new_config.settings.python.analysis.diagnosticMode = "openFilesOnly"
      new_config.settings.python.analysis.typeCheckingMode = "off" -- 型チェック完全無効化
    end
  end,
}
