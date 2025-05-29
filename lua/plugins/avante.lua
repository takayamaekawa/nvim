return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    -- define at settings/avante.lua
    -- -- add any opts here
    -- -- for example
    -- provider = "openai",
    -- openai = {
    --   endpoint = "https://api.openai.com/v1",
    --   model = "gpt-4o",             -- your desired model (or use gpt-4o, etc.)
    --   timeout = 30000,              -- Timeout in milliseconds, increase this for reasoning models
    --   temperature = 0,
    --   max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    --   --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    -- },
  },
  config = function(_, opts_from_lazy)
    -- 外部設定ファイルを require する
    -- 'custom_configs.avante_setup' は lua/custom_configs/avante_setup.lua を指す
    local avante_custom_settings_module = require("settings.avante")

    -- 外部ファイルから設定テーブルを取得
    local custom_opts = avante_custom_settings_module.opts

    -- lazy.nvim の opts と外部ファイルの設定をマージする (オプション)
    -- ここでは外部ファイルの設定を優先し、opts_from_lazy をデフォルト値として使用
    local final_opts = vim.tbl_deep_extend("force", opts_from_lazy, custom_opts)
    -- もし外部ファイルの設定を完全に優先し、opts_from_lazy を無視するなら
    -- local final_opts = custom_opts

    -- avante.nvim をセットアップ
    if final_opts and (final_opts.providers.anthropic.api_key or final_opts.providers.openai.api_key) then
      require("avante").setup(final_opts)
      -- vim.notify("avante.nvim の設定が読み込まれました。", vim.log.levels.INFO)

      -- 必要であればキーマッピングなどをここに設定
      -- 例:
      -- vim.keymap.set("n", "<leader>aa", function() require("avante.nvim").ask() end, { desc = "Avante Ask Claude" })
      -- vim.keymap.set("n", "<leader>ao", function() require("avante.nvim").ask({provider_name = "openai"}) end, { desc = "Avante Ask OpenAI" })
    else
      vim.notify("avante.nvim: APIキーが設定されていないため、セットアップをスキップしました。", vim.log.levels.WARN)
    end
  end,
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick",         -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua",              -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua",        -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
