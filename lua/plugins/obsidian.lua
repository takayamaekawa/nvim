return {
  { "oflisback/obsidian-bridge.nvim",  opts = { scroll_sync = true } },
  { "nvim-treesitter/nvim-treesitter", branch = 'master',            lazy = false, build = ":TSUpdate" },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = function()
      local config_path = vim.fn.stdpath('config') .. '/plugins.json'
      local workspaces = {}

      local file = io.open(config_path, 'r')
      if file then
        local content = file:read('*all')
        file:close()

        local ok, config = pcall(vim.json.decode, content)
        if ok and config.plugins and config.plugins.obsidian and config.plugins.obsidian.workspaces then
          workspaces = config.plugins.obsidian.workspaces
        end
      end

      return {
        workspaces = workspaces,
        -- telescope連携を追加
        picker = {
          name = "telescope.nvim",
          mappings = {
            new = "<C-x>",
            insert_link = "<C-l>",
          },
        },

        -- 補完設定
        completion = {
          nvim_cmp = true,
          min_chars = 2,
        },
        -- see below for full list of options 👇
      }
    end,
  }
}
