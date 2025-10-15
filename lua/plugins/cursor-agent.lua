return {
  "xTacobaco/cursor-agent.nvim",
  config = function()
    vim.keymap.set("n", "<C-g>", ":CursorAgent<CR>", { desc = "Cursor Agent: Toggle terminal" })
    vim.keymap.set("v", "<leader>ca", ":CursorAgentSelection<CR>", { desc = "Cursor Agent: Send selection" })
    vim.keymap.set("n", "<leader>cA", ":CursorAgentBuffer<CR>", { desc = "Cursor Agent: Send buffer" })

    -- 縦分割のcursor-agent状態管理
    local vsplit_state = {
      win = nil,
      bufnr = nil,
      job_id = nil,
    }

    -- 右30%の縦分割でcursor-agentを起動/トグルする関数
    local function toggle_cursor_agent_vsplit()
      -- ウィンドウが開いている場合は閉じる
      if vsplit_state.win and vim.api.nvim_win_is_valid(vsplit_state.win) then
        vim.api.nvim_win_close(vsplit_state.win, false)
        vsplit_state.win = nil
        return
      end

      -- ジョブが生きているか確認
      local function job_is_alive(job_id)
        if not job_id or job_id == 0 then return false end
        local ok, res = pcall(vim.fn.jobwait, { job_id }, 0)
        if not ok or type(res) ~= 'table' then return false end
        return res[1] == -1
      end

      -- 既存のバッファがあり、ジョブが生きている場合は再利用
      if vsplit_state.bufnr and vim.api.nvim_buf_is_valid(vsplit_state.bufnr) and job_is_alive(vsplit_state.job_id) then
        vim.cmd("rightbelow vsplit")
        vsplit_state.win = vim.api.nvim_get_current_win()
        local width = math.floor(vim.o.columns * 0.3)
        vim.api.nvim_win_set_width(vsplit_state.win, width)
        vim.api.nvim_win_set_buf(vsplit_state.win, vsplit_state.bufnr)
        vim.cmd("startinsert")
        return
      end

      -- 新しいターミナルを作成
      vim.cmd("rightbelow vsplit")
      vsplit_state.win = vim.api.nvim_get_current_win()
      local width = math.floor(vim.o.columns * 0.3)
      vim.api.nvim_win_set_width(vsplit_state.win, width)

      -- バッファを作成
      vsplit_state.bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_win_set_buf(vsplit_state.win, vsplit_state.bufnr)
      -- バッファをウィンドウが閉じても保持
      vim.api.nvim_buf_set_option(vsplit_state.bufnr, "bufhidden", "hide")

      -- ターミナルを開く
      vsplit_state.job_id = vim.fn.termopen("cursor-agent", {
        on_exit = function(_, code)
          vsplit_state.job_id = nil
        end,
      })

      vim.cmd("startinsert")
    end

    -- Ctrl+aでcursor-agentの縦分割をトグル（ノーマルモード・ターミナルモード共通）
    vim.keymap.set("n", "<C-a>", toggle_cursor_agent_vsplit, { desc = "Cursor Agent: Toggle side split" })
    vim.keymap.set("t", "<C-a>", toggle_cursor_agent_vsplit, { desc = "Cursor Agent: Toggle side split" })

    -- ターミナルモードでCtrl+gを押すとノーマルモードに戻り、ウィンドウを閉じる
    vim.keymap.set("t", "<C-g>", function()
      -- ノーマルモードに戻る
      vim.cmd("stopinsert")
      -- 現在のウィンドウを閉じる（バッファは残る）
      vim.api.nvim_win_close(0, false)
    end, { desc = "Exit terminal mode and close window" })
  end,
}
