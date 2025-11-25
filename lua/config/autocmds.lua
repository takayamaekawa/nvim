-- autocmds.lua
-- 自動コマンドの設定

-- .ipynb ファイルを Python として扱う
-- jsonls が起動しないようにする
-- jupytextプラグインがロードされた後に実行されるように遅延させる
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*.ipynb",
  callback = function()
    -- 少し遅延させてjupytextの処理を待つ
    vim.defer_fn(function()
      if vim.bo.filetype == "json" or vim.bo.filetype == "" then
        vim.bo.filetype = "python"
      end
    end, 100)
  end,
})
