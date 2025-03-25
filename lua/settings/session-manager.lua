local M = {}

M.setup = function()
    require("session_manager").setup({
    -- セッションファイルの保存場所
    session_dir = vim.fn.stdpath("data") .. "/sessions/",

    -- 自動保存の間隔 (秒)
    auto_save_interval = 60,

    -- セッションファイルの拡張子
    session_filename = ".session",

    -- セッションを自動的に読み込むかどうか
    auto_session_enable = true,

    -- カレントディレクトリをセッション名として使用するかどうか
    use_git_branch = true,

    -- 除外するファイルパターン
    exclude_filetypes = {"NvimTree", "vista", "toggleterm"},
  })
end

function M.check_and_load_session()
  vim.cmd("silent SessionManager current_dir_session_exists")
  local session_exists = vim.v.shell_error == 0

  if session_exists then
    vim.cmd("SessionManager load_current_dir_session")
  end
end

return M
