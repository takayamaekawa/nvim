-- lua/settings/lint.lua
local lint = require("lint")

lint.linters_by_ft = {
  javascript = { "biome" },
  typescript = { "biome" },
  javascriptreact = { "biome" },
  typescriptreact = { "biome" },
  json = { "biome" },
  jsonc = { "biome" },
  -- 他の言語のLinterもここに追加できる
  -- python = { "ruff" },
}

-- 保存時とテキスト変更時に自動でLintを実行する設定
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("lint", { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
