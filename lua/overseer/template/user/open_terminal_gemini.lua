return {
  name = "Open Gemini in Tab",
  builder = function()
    return {
      cmd = { "gemini" },
      components = { "default" },
      strategy = {
        "toggleterm",
        direction = "tab",
        hidden = true, -- タブをリストに表示しない
      },
      -- タスク開始時にタブへ移動
      on_start = function()
        vim.defer_fn(function()
          vim.cmd("tabnext")
        end, 100) -- 100ms 後にタブ移動（即座に移動すると意図しない挙動を防げる）
      end,
    }
  end,
}
