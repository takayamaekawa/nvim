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
    
    -- ボーダーの設定（8要素が必要: top-left, top, top-right, right, bottom-right, bottom, bottom-left, left）
    vim.g.molten_output_win_border = { "", "─", "", "", "", "─", "", "" }
    
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
      -- MoltenEnterOutputで出力ウィンドウに入る
      local ok = pcall(vim.cmd, "MoltenEnterOutput")
      if not ok then
        vim.notify("No output window found", vim.log.levels.WARN)
        return
      end
      
      -- 少し待ってからバッファの内容を取得
      vim.defer_fn(function()
        local bufnr = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local text = table.concat(lines, "\n")
        
        if text and text ~= "" then
          -- クリップボードにコピー
          vim.fn.setreg('+', text)
          vim.fn.setreg('"', text)
          
          vim.notify("Output copied to clipboard (" .. #lines .. " lines)", vim.log.levels.INFO)
        else
          vim.notify("Output is empty", vim.log.levels.WARN)
        end
        
        -- 元のウィンドウに戻る
        vim.cmd("quit")
      end, 50)
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
  end,
}
