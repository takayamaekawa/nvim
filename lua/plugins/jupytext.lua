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
  end,
}
