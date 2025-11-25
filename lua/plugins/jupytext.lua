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
  end,
}
