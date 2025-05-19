local M = {}

local api = require("nvim-tree.api")

local map = vim.keymap.set

local function open_and_return()
  api.node.open.edit() -- ファイルを開く
  vim.cmd("wincmd p")  -- 直前のウィンドウ（ツリー）に戻る
end

M.on_attach = function(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- デフォルトの `on_attach` も実行（必要に応じてカスタマイズ）
  api.config.mappings.default_on_attach(bufnr)

  -- "O" キーに open_and_return をマッピング
  map("n", "O", open_and_return, opts("Open and Return to Tree"))
  -- "z" キーで全フォルダ折りたたみ
  map("n", "z", api.tree.collapse_all, opts("Collapse All"))
end

return M
