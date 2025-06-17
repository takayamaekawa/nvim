-- suggestionsの利用データを無効化
vim.g.copilot_filetypes = {
  ["*"] = {
    suggestion = {
      -- trueにすると、あなたのコードスニペットがGitHubに送信されなくなります。
      disable = false,
      -- この設定項目は存在しませんが、代わりに `vim.g.copilot_disable_telemetry` を使います。
      -- 下記の設定でテレメトリを無効化します。
    },
  },
}

-- テレメトリ（利用状況のデータ収集）をグローバルに無効化
-- これにより、あなたのコードが学習に使われるのを防ぎます。
vim.g.copilot_disable_telemetry = true

-- もしCopilotChatを別途設定している場合
-- こちらは CopilotChat.nvim の設定ですが、念のため記述しておきます。
require("CopilotChat").setup {
  -- trueにすると、チャット内容がGitHubに送信されなくなります。
  disable_telemetry = true,
}
