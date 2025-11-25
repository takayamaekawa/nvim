-- notebook-navigator.lua
-- Jupyter notebookのセル移動・実行を管理するプラグイン
-- #%% で囲まれた箇所を1つのセルとして扱う
-- markdownのコードブロックもセルとして認識

return {
  "GCBallesteros/NotebookNavigator.nvim",
  keys = {
    -- セル内のコードを実行して自動保存
    { "<leader>rc", function() 
        require("notebook-navigator").run_cell()
        -- 少し待ってから保存（セル実行が完了するのを待つ）
        vim.defer_fn(function()
          vim.cmd("silent! write")
        end, 100)
      end, desc = "Run Cell and Save" },
    -- セル内のコードを実行して次のセルに移動して自動保存
    { "<leader>rm", function() 
        require("notebook-navigator").run_and_move()
        vim.defer_fn(function()
          vim.cmd("silent! write")
        end, 100)
      end, desc = "Run Cell, Move and Save" },
    -- 上のセルに移動
    { "[c", function() require("notebook-navigator").move_cell('u') end, desc = "Move to Cell Above" },
    -- 下のセルに移動
    { "]c", function() require("notebook-navigator").move_cell('d') end, desc = "Move to Cell Below" },
    -- カーネルを再起動
    { "<leader>rk", function() vim.cmd("MoltenRestart") end, desc = "Restart Kernel" },
  },
  dependencies = {
    "benlubas/molten-nvim",
    "anuvyklack/hydra.nvim",
  },
  config = function()
    local nn = require("notebook-navigator")
    nn.setup({
      -- セルマーカーの設定
      cell_markers = {
        python = "# %%",
      },
      -- molten-nvimと連携してコードを実行
      activate_hydra_keys = nil,
      show_hydra_hint = false,
      repl_provider = "molten",
      -- markdownのコードブロックをセルとして認識
      syntax = {
        python = {
          -- コードブロックの開始を認識
          cell_marker = "^```python",
        },
      },
    })
  end,
  ft = { "python", "ipynb" },
}
