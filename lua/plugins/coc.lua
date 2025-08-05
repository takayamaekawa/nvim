-- COC全体の切り替えフラグ (true: COC使用, false: LSP直接使用)
local USE_COC = false

-- COCを無効化する場合は空テーブルを返す
if not USE_COC then
  return {}
end

return {
  'neoclide/coc.nvim',
  branch = 'release',
  build = 'npm ci',
  config = function()
    -- coc.nvimの基本設定
    vim.g.coc_global_extensions = {
      'coc-java',
      'coc-json',
      'coc-tsserver',
      'coc-html',
      'coc-css',
      'coc-snippets'
    }
    
    -- 補完UIを無効化してnvim-cmpに委譲
    vim.g.coc_suggest_disable = 1

    -- 補完キーマップを無効化（nvim-cmpに委譲）
    -- vim.keymap.set('i', '<C-j>', function()
    --   if vim.fn['coc#pum#visible']() == 1 then
    --     return vim.fn['coc#pum#next'](1)
    --   else
    --     return vim.fn['coc#refresh']()
    --   end
    -- end, { expr = true, silent = true })

    -- vim.keymap.set('i', '<C-k>', function()
    --   if vim.fn['coc#pum#visible']() == 1 then
    --     return vim.fn['coc#pum#prev'](1)
    --   else
    --     return vim.fn['coc#refresh']()
    --   end
    -- end, { expr = true, silent = true })

    -- vim.keymap.set('i', '<CR>', function()
    --   if vim.fn['coc#pum#visible']() == 1 then
    --     return vim.fn['coc#pum#confirm']()
    --   else
    --     return "<CR>"
    --   end
    -- end, { expr = true, silent = true })

    -- エラー診断のナビゲーション
    vim.api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', { noremap = false })
    vim.api.nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', { noremap = false })

    -- コード定義・参照
    vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { noremap = false })
    vim.api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', { noremap = false })
    vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { noremap = false })
    vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { noremap = false })

    -- ホバー情報
    vim.api.nvim_set_keymap('n', 'K', ':call CocActionAsync("doHover")<CR>', { noremap = true, silent = true })

    -- リネーム
    vim.api.nvim_set_keymap('n', '<leader>rn', '<Plug>(coc-rename)', { noremap = false })

    -- コードフォーマット
    vim.api.nvim_set_keymap('x', '<leader>f', '<Plug>(coc-format-selected)', { noremap = false })
    vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>(coc-format)', { noremap = false })

    -- 補完トリガーも無効化（nvim-cmpに委譲）
    -- vim.keymap.set('i', '<C-Space>', 'coc#refresh()', { expr = true, silent = true })
  end
}

