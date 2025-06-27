-- gitsigns.nvim が存在するか安全にチェック
local gitsigns_available, gitsigns = pcall(require, 'gitsigns')

-- ModeGitの本体となる関数
local function start_git_hunk_listener()
  -- プラグインがインストールされていない場合は処理を中断
  if not gitsigns_available then
    vim.notify("gitsigns.nvim is not installed.", vim.log.levels.ERROR)
    return
  end

  -- モードに入ったことをユーザーに通知
  vim.notify("Git Hunk Navigation: [n]ext, [N]previous, [q]uit or <Esc>", vim.log.levels.INFO, {
    title = "Git Mode Active"
  })
  print("Git Hunk Navigation: Press 'n' (next), 'N' (previous), or 'q' to quit.")

  -- キー入力をリッスンする内部関数
  local function listen()
    local char_code = vim.fn.getchar()
    local key = vim.fn.nr2char(char_code)

    if key == 'n' then
      gitsigns.next_hunk()
      listen() -- 次の入力を待つ
    elseif key == 'N' then
      gitsigns.prev_hunk()
      listen()                                                   -- 次の入力を待つ
    elseif key == 'q' or char_code == 27 or char_code == 13 then -- 'q'キー または Escキー
      print("Exited Git Hunk Navigation.")
      vim.cmd('redraw')                                          -- コマンドラインのメッセージをクリア
      return                                                     -- ループを終了
    else
      -- その他のキーが押された場合は、モードを継続して次の入力を待つ
      listen()
    end
  end

  -- 最初のリスナーを起動
  listen()
end

-- :ModeGit コマンドを作成
vim.api.nvim_create_user_command(
  'ModeGit',
  start_git_hunk_listener,
  {
    nargs = 0,
    desc = "Enter a temporary mode to navigate git hunks with 'n' and 'N'"
  }
)
