return {
  name = "Run Gemini Web Search Program",
  builder = function()
    -- ユーザーに入力を促す
    local search_query = vim.fn.input("Geminiで検索: ")
    local term_size = math.floor(vim.o.columns / 2)

    return {
      -- 修正点: コマンドの末尾に "; exec bash" を追加
      cmd = { "bash", "-c", "gemini -p \"" .. search_query .. "\"; exec bash" },
      components = { "default" },
      -- see https://github.com/stevearc/overseer.nvim/blob/master/doc/strategies.md#terminal
      strategy = {
        "toggleterm",
        direction = "vertical",
        size = term_size,
        hidden = true,
      },
    }
  end,
}
