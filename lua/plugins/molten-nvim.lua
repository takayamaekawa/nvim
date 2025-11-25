-- molten-nvim.lua
-- Python コードを実行し、結果をNeovimエディタ上に表示するプラグイン
-- Jupyter カーネルと通信して実行結果を取得する

return {
  "benlubas/molten-nvim",
  version = "^1.0.0", -- 安定版を使用
  lazy = false, -- 起動時にロード
  dependencies = {
    "3rd/image.nvim", -- 画像表示のために必要
  },
  build = ":UpdateRemotePlugins", -- インストール後にリモートプラグインを更新
  init = function()
    -- molten の基本設定
    -- 出力ウィンドウの表示スタイル
    vim.g.molten_output_win_style = "minimal" -- minimal: シンプルな表示
    
    -- 画像プロバイダーの設定
    -- kitty graphics protocol を使用
    vim.g.molten_image_provider = "image.nvim"
    
    -- 自動的に出力ウィンドウを開く
    vim.g.molten_auto_open_output = true
    
    -- 出力の最大表示高さ（行数）
    vim.g.molten_output_win_max_height = 20
    
    -- セルの実行結果を仮想テキストとして表示するか
    -- ※画像が乱れることがあるため false 推奨
    vim.g.molten_virt_text_output = false
    
    -- 複数行の出力を折りたたむか
    vim.g.molten_wrap_output = true
    
    -- 出力ウィンドウのハイライト設定
    vim.g.molten_output_show_more = true
    
    -- ボーダーの設定（各要素は [文字, ハイライトグループ] のタプル形式）
    -- top-left, top, top-right, right, bottom-right, bottom, bottom-left, left
    vim.g.molten_output_win_border = {
      {"", ""}, {"─", ""}, {"", ""}, {"", ""},
      {"", ""}, {"─", ""}, {"", ""}, {"", ""}
    }
    
    -- カーネルの自動初期化
    vim.g.molten_auto_init_behavior = "init"
    
    -- 自動保存を無効化（実行時にファイルが変更されないように）
    vim.g.molten_auto_image_popup = false
    vim.g.molten_save_path = vim.fn.stdpath("data") .. "/molten" -- 出力は別の場所に保存
  end,
  -- keysは削除してlazy loadしない
  config = function()
    -- セルの出力をクリップボードにコピーする関数
    local function copy_cell_output()
      -- 出力ウィンドウを探す
      local output_bufnr = nil
      local output_winid = nil
      
      -- 全てのウィンドウをチェック
      for _, winid in ipairs(vim.api.nvim_list_wins()) do
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        
        -- molten出力バッファを探す（バッファ名またはfiletypeで判定）
        local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
        if buftype == 'nofile' and bufname:match('molten') then
          output_bufnr = bufnr
          output_winid = winid
          break
        end
      end
      
      -- 出力バッファが見つからない場合、別の方法を試す
      if not output_bufnr then
        -- フローティングウィンドウを探す
        for _, winid in ipairs(vim.api.nvim_list_wins()) do
          local win_config = vim.api.nvim_win_get_config(winid)
          if win_config.relative ~= '' then  -- フローティングウィンドウ
            local bufnr = vim.api.nvim_win_get_buf(winid)
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 5, false)
            -- 最初の数行に出力っぽい内容があれば採用
            if #lines > 0 and lines[1] ~= '' then
              output_bufnr = bufnr
              output_winid = winid
              break
            end
          end
        end
      end
      
      if not output_bufnr then
        vim.notify("No output found. Try running a cell first.", vim.log.levels.WARN)
        return
      end
      
      -- バッファの内容を取得
      local lines = vim.api.nvim_buf_get_lines(output_bufnr, 0, -1, false)
      local text = table.concat(lines, "\n")
      
      if text and text ~= "" then
        -- クリップボードにコピー
        vim.fn.setreg('+', text)
        vim.fn.setreg('"', text)
        
        -- システムクリップボードにもコピーを試みる
        if vim.fn.has('clipboard') == 1 then
          vim.fn.setreg('*', text)
        end
        
        vim.notify("Output copied to clipboard (" .. #lines .. " lines)", vim.log.levels.INFO)
      else
        vim.notify("Output is empty", vim.log.levels.WARN)
      end
    end
    
    -- キーマッピング設定
    vim.keymap.set("n", "<leader>ro", ":MoltenEvaluateOperator<CR>", { desc = "Molten Evaluate Operator", silent = true })
    vim.keymap.set("v", "<leader>rv", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Molten Evaluate Visual", silent = true })
    vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<CR>", { desc = "Molten Evaluate Line", silent = true })
    vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>", { desc = "Molten Re-evaluate Cell", silent = true })
    vim.keymap.set("n", "<leader>rd", ":MoltenDelete<CR>", { desc = "Molten Delete Output", silent = true })
    vim.keymap.set("n", "<leader>ri", ":MoltenInit<CR>", { desc = "Molten Initialize Kernel", silent = true })
    vim.keymap.set("n", "<leader>rh", ":MoltenHideOutput<CR>", { desc = "Molten Hide Output", silent = true })
    vim.keymap.set("n", "<leader>rs", ":MoltenShowOutput<CR>", { desc = "Molten Show Output", silent = true })
    vim.keymap.set("n", "<leader>ry", copy_cell_output, { desc = "Molten Copy Output to Clipboard", silent = true })
    
    -- デバッグ用: 出力バッファ情報を表示
    vim.keymap.set("n", "<leader>rY", function()
      local info = {}
      table.insert(info, "=== Window Information ===")
      
      for _, winid in ipairs(vim.api.nvim_list_wins()) do
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
        local win_config = vim.api.nvim_win_get_config(winid)
        local is_float = win_config.relative ~= ''
        
        table.insert(info, string.format("Win %d: buf=%d, type=%s, float=%s", 
          winid, bufnr, buftype, is_float))
        table.insert(info, string.format("  name: %s", bufname))
        
        if is_float then
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 3, false)
          table.insert(info, "  first 3 lines: " .. vim.inspect(lines))
        end
      end
      
      vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
    end, { desc = "Molten Debug Output Info", silent = true })
  end,
}
