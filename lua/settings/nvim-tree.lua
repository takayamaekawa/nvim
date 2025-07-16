require("nvim-tree").setup({
  on_attach = require("settings.keymaps.plugins.nvim-tree").on_attach,
  diagnostics = {
    enable = true,       -- LSPの診断情報を有効化
    show_on_dirs = true, -- ディレクトリにもエラー表示
    debounce_delay = 50,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  view = {
    adaptive_size = false, -- ウィンドウサイズに応じて幅を調整しない
    width = math.floor(vim.fn.winwidth(0) * 0.15),
    side = "left",
    float = {
      enable = false,
    },
  },
  renderer = {
    group_empty = true -- 空のフォルダをまとめて折りたたむ
  },
})
