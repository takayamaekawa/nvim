-- jupytext.lua
-- *.ipynb ファイルを自動的にPython形式で開き、保存時にipynbに変換するプラグイン

return {
  "GCBallesteros/jupytext.nvim",
  lazy = false, -- 起動時に必ずロード
  priority = 1000, -- 高優先度で最初にロード
  config = function()
    require("jupytext").setup({
      style = "percent", -- "percent" は # %% 形式のセル区切りを使用
      output_extension = "auto", -- 自動的に拡張子を決定
      force_ft = "python", -- 強制的にPythonファイルタイプとして扱う
      custom_language_formatting = {
        python = {
          extension = "py",
          style = "percent",
          force_ft = "python",
        },
      },
    })
    
    -- .ipynb保存用のカスタムコマンド
    vim.api.nvim_create_user_command("JupytextSync", function()
      local current_file = vim.fn.expand("%:p")
      local ipynb_exists = vim.fn.filereadable(current_file) == 1
      
      -- 一時的な.pyファイルとして保存
      local py_file = current_file:gsub("%.ipynb$", ".py")
      vim.cmd("write! " .. vim.fn.fnameescape(py_file))
      
      -- jupytextコマンドで.ipynbに変換（上書き）
      local cmd = string.format("jupytext --to=ipynb --output=%s %s", 
        vim.fn.shellescape(current_file), 
        vim.fn.shellescape(py_file))
      local result = vim.fn.system(cmd)
      
      if vim.v.shell_error == 0 then
        vim.notify(ipynb_exists and "Updated " .. vim.fn.fnamemodify(current_file, ":t") or "Created " .. vim.fn.fnamemodify(current_file, ":t"), vim.log.levels.INFO)
        vim.bo.modified = false
      else
        vim.notify("Failed to sync: " .. result, vim.log.levels.ERROR)
      end
    end, {})
    
    -- ipynbファイルを開いた時にLSP設定を最適化
    vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
      pattern = "*.ipynb",
      callback = function()
        -- pyrightクライアントを取得
        vim.defer_fn(function()
          local clients = vim.lsp.get_clients({ bufnr = 0, name = "pyright" })
          for _, client in ipairs(clients) do
            if client.config.settings then
              -- notebookファイル用の診断モードを設定
              client.config.settings.python = client.config.settings.python or {}
              client.config.settings.python.analysis = client.config.settings.python.analysis or {}
              client.config.settings.python.analysis.diagnosticMode = "openFilesOnly"
              -- 設定を再送信
              client.notify("workspace/didChangeConfiguration", {
                settings = client.config.settings
              })
            end
          end
        end, 1000)  -- LSPが起動するまで少し待つ
      end,
    })
  end,
}
