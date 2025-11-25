-- image-nvim.lua
-- 画像をNeovimエディタ上に表示するプラグイン
-- iTerm2 の inline image protocol を使用

return {
  "3rd/image.nvim",
  lazy = false, -- 起動時にロード
  priority = 900, -- moltenより先にロード
  dependencies = {
    "leafo/magick", -- ImageMagick の Lua バインディング（luarocks でインストール済み）
  },
  config = function()
    require("image").setup({
      backend = "kitty", -- kitty graphics protocol を使用
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
        -- Molten (Jupyter) との統合設定
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil, -- 最大幅（nil = 制限なし）
      max_height = nil, -- 最大高さ（nil = 制限なし）
      max_width_window_percentage = nil, -- ウィンドウ幅に対する最大パーセンテージ
      max_height_window_percentage = 50, -- ウィンドウ高さの50%まで
      window_overlap_clear_enabled = false, -- ウィンドウが重なったときに画像をクリアするか
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false, -- エディタがフォーカスされているときのみ描画
      tmux_show_only_in_active_window = false, -- tmux使用時はアクティブウィンドウのみ
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" }, -- 自動的に画像として開くパターン
    })
    
    -- molten用にグローバルに登録
    _G.load_image_nvim = {
      image_api = require("image")
    }
  end,
}
