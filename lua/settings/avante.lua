local M = {}

-- APIキーの読み込みやその他のロジックをここに記述
local anthropic_api_key = os.getenv("ANTHROPIC_API_KEY")
if not anthropic_api_key then
  vim.notify("ANTHROPIC_API_KEY が設定されていません。", vim.log.levels.WARN)
end

-- use openai settings
-- local openai_api_key = os.getenv("OPENAI_API_KEY")
-- if not openai_api_key then
--   vim.notify("OPENAI_API_KEY が設定されていません。", vim.log.levels.WARN)
-- end

-- avante.nvim の設定テーブルを定義
M.opts = {
  providers = {
    anthropic = {
      name = "claude",
      api_key = anthropic_api_key,
      default_model = "claude-3-sonnet-20240229", -- Opusより少し安価で高速なSonnetをデフォルトにしてみる例
      timeout = 60000,
      temperature = 0.7,
      max_completion_tokens = 4096,
    },
    -- openai = {
    --   api_key = openai_api_key,
    --   endpoint = "https://api.openai.com/v1",
    --   model = "gpt-4o",
    --   timeout = 30000,
    --   temperature = 0.7, -- 少し創造性を上げるために0以外にしてみる例
    --   max_completion_tokens = 8192,
    -- },
  },
  default_provider = "claude", -- デフォルトで使用するプロバイダを名前で指定
  -- その他の avante.nvim の設定項目があればここに追加
  -- 例:
  -- ui = {
  --   border = "rounded",
  -- },
}

-- モジュールとしてこの設定テーブルを返す
return M
