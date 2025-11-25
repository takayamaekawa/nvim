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

-- 新規 .ipynb ファイル作成時のテンプレート挿入
vim.api.nvim_create_autocmd({ "BufNewFile" }, {
  pattern = "*.ipynb",
  callback = function()
    -- 遅延実行でjupytextの処理を待つ
    vim.defer_fn(function()
      -- Pythonファイルタイプとして設定
      vim.bo.filetype = "python"
      
      -- バッファが空の場合のみテンプレートを挿入
      local line_count = vim.api.nvim_buf_line_count(0)
      if line_count == 1 and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "" then
        -- jupytextヘッダーとサンプルセルを挿入
        local lines = {
          "# ---",
          "# jupyter:",
          "#   jupytext:",
          "#     text_representation:",
          "#       extension: .py",
          "#       format_name: percent",
          "#       format_version: '1.3'",
          "#       jupytext_version: 1.18.1",
          "#   kernelspec:",
          "#     display_name: Python 3",
          "#     language: python",
          "#     name: python3",
          "# ---",
          "",
          "# %% [markdown]",
          "# # New Notebook",
          "#",
          "# Description here...",
          "",
          "# %%",
          "# First code cell",
          "print('Hello, Jupyter!')",
          "",
        }
        
        -- バッファに行を挿入
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        
        -- カーソルを最後のセルに移動
        vim.api.nvim_win_set_cursor(0, {#lines - 1, 0})
        
        -- 変更済みフラグを立てる
        vim.bo.modified = true
      end
    end, 200)
  end,
})
