-- WSL環境の場合はホストIP、そうでなければlocalhostを返す関数
local function get_obsidian_host()
  -- WSL_DISTRO_NAME環境変数が存在するかチェック
  local wsl_distro = os.getenv("WSL_DISTRO_NAME")
  if wsl_distro then
    -- WSL環境の場合、ホストIPを取得
    local handle = io.popen("ip route show default | awk '{print $3}'")
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s+", "") -- 改行文字を削除
  else
    -- WSL環境でない場合はlocalhost
    return "localhost"
  end
end

-- obsidian-bridge.nvimの設定
local bridge_settings = {
  obsidian_server_address = "http://" .. get_obsidian_host() .. ":27123",
  scroll_sync = true, -- バッファスクロールの同期を有効
  cert_path = nil,
  warnings = true,
  picker = "telescope",
}

return {
  {
    "oflisback/obsidian-bridge.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = bridge_settings,
    event = {
      "BufReadPre *.md",
      "BufNewFile *.md",
    },
    lazy = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate"
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.nvim'
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      local config_path = vim.fn.stdpath('config') .. '/plugins.json'
      local workspaces = {
        {
          name = "personal",
          path = "~/vaults/personal",
        },
      }

      -- plugins.jsonから設定を読み込み
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

        -- telescope連携
        picker = {
          name = "telescope.nvim",
          mappings = {
            new = "<C-x>",
            insert_link = "<C-l>",
          },
        },

        completion = {
          nvim_cmp = true,
          min_chars = 2,
        },

        -- API設定（環境に応じて動的にホストを決定）
        api = {
          host = get_obsidian_host(),
          port = 27123,
        },

        -- WSL環境でWindowsのアプリケーションを使用してURLを開く
        follow_url_func = function(url)
          local wsl_distro = os.getenv("WSL_DISTRO_NAME")
          if wsl_distro then
            -- WSL環境: Windowsのデフォルトブラウザで開く
            vim.fn.jobstart({ "cmd.exe", "/c", "start", url }, { detach = true })
          else
            -- 通常のLinux環境
            vim.fn.jobstart({ "xdg-open", url }, { detach = true })
          end
        end,

        follow_img_func = function(img)
          local wsl_distro = os.getenv("WSL_DISTRO_NAME")
          if wsl_distro then
            -- WSL環境: Windowsのデフォルト画像ビューアで開く
            vim.fn.jobstart({ "cmd.exe", "/c", "start", img }, { detach = true })
          else
            -- 通常のLinux環境
            vim.fn.jobstart({ "xdg-open", img }, { detach = true })
          end
        end,
      }
    end,
  }
}
