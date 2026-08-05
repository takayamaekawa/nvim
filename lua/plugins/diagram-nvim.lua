-- diagram-nvim.lua
-- markdown 内の mermaid / PlantUML / D2 コードブロックを画像として描画する
-- レンダリングには image.nvim を使用し、mermaid は mmdc (mermaid-cli) で画像化する

return {
  "3rd/diagram.nvim",
  dependencies = {
    "3rd/image.nvim",
  },
  ft = { "markdown", "norg" },
  opts = {
    events = {
      render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
      clear_buffer = { "BufLeave" },
    },
    renderer_options = {
      mermaid = {
        theme = "default", -- default / forest / dark / neutral
        background = "white", -- 透過にする場合は "transparent"
        scale = 2, -- 高解像度化（Retina向け）
      },
    },
  },
}
