return {
  name = "Run Gemini Web Search Program",
  builder = function()
    local search_query = vim.fn.input("Geminiに質問: ")
    if search_query == "" then
      return
    end
    local term_size = math.floor(vim.o.columns / 2)
    local log_dir = os.getenv("HOME") .. "/log/gemini-cli/" .. os.date("%Y-%m-%d")
    vim.fn.mkdir(log_dir, "p")
    local log_file = log_dir .. "/" .. os.date("%H-%M-%S") .. ".log"
    local command = string.format(
      'echo "Q: %s" | tee %q; gemini -p %q | tee -a %q; ' ..
      "exec zsh -c 'while read -p \"gemini> \" query; do " ..
      "if [[ -z \\\"$query\\\" ]]; then break; fi; " ..
      "echo \"\" | tee -a %q; echo \"Q: $query\" | tee -a %q; " ..
      "gemini -p \"$query\" | tee -a %q; " ..
      "history -s \"$query\"; " ..
      "done'",
      search_query, log_file, search_query, log_file,
      log_file, log_file, log_file
    )

    return {
      cmd = { "zsh", "-c", command },
      components = {
        "on_exit_set_status",
      },
      strategy = {
        "toggleterm",
        direction = "vertical",
        size = term_size,
        hidden = true,
      },
    }
  end,
}
