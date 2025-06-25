-- lua/overseer/template/user/run_gemini_web_search_program.lua
return {
  name = "Run Gemini Web Search Program",
  builder = function()
    local search_query = vim.fn.input("最初のプロンプトを入力: ")
    if search_query == "" then
      return
    end
    local term_size = math.floor(vim.o.columns / 2)
    local log_dir = os.getenv("HOME") .. "/log/gemini-cli/" .. os.date("%Y-%m-%d")
    vim.fn.mkdir(log_dir, "p")
    local log_file = log_dir .. "/" .. os.date("%H-%M-%S") .. ".log"

    --------------------------------------------------
    -- ここからが変更点
    --------------------------------------------------
    local command = string.format(
    -- 外側のシェルはCtrl+Cを無視する
      "trap '' SIGINT; " ..
      -- 実行するコマンドグループ
      "(echo \"Q: %s\" | tee %q; gemini -p %q | tee -a %q; " ..
      -- execで起動する内側のシェルで、Ctrl+Cの設定をデフォルトに戻す
      "exec bash -c 'trap - SIGINT; " ..
      "while read -p \"gemini> \" query; do " ..
      "if [[ -z \\\"$query\\\" ]]; then break; fi; " ..
      "echo \"\" | tee -a %q; echo \"Q: $query\" | tee -a %q; " ..
      "gemini -p \"$query\" | tee -a %q; " ..
      "history -s \"$query\"; " ..
      "done') " ..
      -- 最終的にコマンド全体が失敗しても、成功(0)を返す
      "|| true",
      search_query, log_file, search_query, log_file,
      log_file, log_file, log_file
    )
    --------------------------------------------------
    -- 変更点ここまで
    --------------------------------------------------

    return {
      cmd = { "bash", "-c", command },
      components = { "on_exit_set_status" },
      strategy = {
        "toggleterm",
        direction = "vertical",
        size = term_size,
        hidden = true,
      },
    }
  end,
}
