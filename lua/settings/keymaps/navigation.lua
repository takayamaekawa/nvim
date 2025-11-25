local map = vim.api.nvim_set_keymap
local fmap = vim.keymap.set
local opts = { noremap = true, silent = true }

local workspace_picker = require('impl.workspacePicker')
local python_env_picker = require('impl.pythonEnvPicker')

-- buffer
-- move to the previous/next one
map('n', '<C-j>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<C-k>', '<Cmd>BufferNext<CR>', opts)
-- move into the previous one
map('n', '<C-H>', '<Cmd>BufferMovePrevious<CR>', opts)
-- move into the next one
map('n', '<C-L>', '<Cmd>BufferMoveNext<CR>', opts)
-- close
map('n', '<leader>ww', '<Cmd>BufferClose<CR>', opts)
map('n', '<leader>wc', '<Cmd>close<CR>', opts)

local is_mac = vim.loop.os_uname().sysname == "Darwin"
local tabnext_key = is_mac and '<C-]>' or '<C-\\><C-_>'
local tabprev_key = is_mac and '<C-[>' or '<C-\\><C-\\>'
local tabclose_key = is_mac and '<C-@>' or '<C-\\><C-w>'

fmap('n', tabnext_key, function() vim.cmd("tabnext") end, opts)
fmap('t', tabnext_key, function() vim.cmd("tabnext") end, opts)
fmap('n', tabprev_key, function() vim.cmd("tabprevious") end, opts)
fmap('t', tabprev_key, function() vim.cmd("tabprevious") end, opts)
fmap('n', tabclose_key, function() vim.cmd("tabclose") end, opts)
fmap('t', tabclose_key, function() vim.cmd("tabclose") end, opts)
fmap('t', '<C-\\><C-h>', '<C-\\><C-n><C-w>h', opts)
fmap('t', '<C-\\><C-j>', '<C-\\><C-n><C-w>j', opts)
fmap('t', '<C-\\><C-k>', '<C-\\><C-n><C-w>k', opts)
fmap('t', '<C-\\><C-l>', '<C-\\><C-n><C-w>l', opts)


-- window
-- close
fmap('n', '<C-w>0', '<Cmd>close<CR>')
-- move by alt key
fmap('n', '<A-Left>', '<C-w>h')
fmap('n', '<A-Down>', '<C-w>j')
fmap('n', '<A-Up>', '<C-w>k')
fmap('n', '<A-Right>', '<C-w>l')

-- tab
-- <leader>tc: close the current tab
fmap('n', '<leader>tc', function() vim.cmd("tabclose") end, opts)

-- obsidian
fmap('n', '<leader>on', '<Cmd>ObsidianNew<CR>', opts)         -- 新しいノート作成
fmap('n', '<leader>os', '<Cmd>ObsidianSearch<CR>', opts)      -- ノート検索
fmap('n', '<leader>oq', '<Cmd>ObsidianQuickSwitch<CR>', opts) -- クイックスイッチ
fmap('n', '<leader>of', '<Cmd>ObsidianFollowLink<CR>', opts)  -- リンクをフォロー
fmap('n', '<leader>ob', '<Cmd>ObsidianBacklinks<CR>', opts)   -- バックリンク表示
fmap('n', '<leader>ot', '<Cmd>ObsidianTags<CR>', opts)        -- タグ検索
fmap('n', '<leader>oo', '<Cmd>ObsidianOpen<CR>', opts)        -- Obsidianアプリで開く
fmap('n', '<leader>ol', '<Cmd>ObsidianLinkNew<CR>', opts)     -- 新しいリンク作成
fmap('n', '<leader>or', '<Cmd>ObsidianRename<CR>', opts)      -- ノート名変更
fmap('n', '<leader>od', '<Cmd>ObsidianToday<CR>', opts)       -- 今日のノート
fmap('n', '<leader>oy', '<Cmd>ObsidianYesterday<CR>', opts)   -- 昨日のノート
fmap('n', '<leader>ot', '<Cmd>ObsidianTomorrow<CR>', opts)    -- 明日のノート

fmap('n', '<leader>ow', '<Cmd>ObsidianWorkspace<CR>', opts)
fmap('n', '<leader>og', '<Cmd>ObsidianBridgeOpenGraph<CR>', opts) -- グラフ表示

-- workspace
fmap('n', '<leader>pp', function() workspace_picker.show_workspaces() end, opts) -- ワークスペースピッカー

-- python environment
fmap('n', '<leader>pe', function() python_env_picker.show_python_envs() end, opts) -- Python環境ピッカー
