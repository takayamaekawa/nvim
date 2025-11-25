---@types vim.lsp.Config
return {
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
        useLibraryCodeForTypes = true,
        -- notebookセルの分析を改善
        autoImportCompletions = true,
      }
    }
  },
  -- ファイル変更通知を最適化
  flags = {
    debounce_text_changes = 300,  -- テキスト変更の通知を遅延（デフォルト150ms → 300ms）
  },
  -- Jupyterノートブック用の最適化
  on_new_config = function(new_config, new_root_dir)
    -- ipynbファイルの場合、特別な設定を適用
    if vim.bo.filetype == "python" and vim.fn.expand("%:e") == "ipynb" then
      new_config.settings.python.analysis.diagnosticMode = "openFilesOnly"
    end
  end,
}
