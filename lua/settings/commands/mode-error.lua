-- diagnostic navigation モードを開始する関数
local function start_diagnostic_listener()
  -- モードに入ったことをユーザーに通知する
  -- vim.notify は数秒で消えるポップアップメッセージです
  vim.notify("Diagnostic navigation: [n]ext, [N]previous, [q]uit or <Esc>", vim.log.levels.INFO, {
    title = "Listener Active"
  })
  -- print はコマンドラインにメッセージを表示します
  print("Diagnostic navigation mode active. Press 'n', 'N', 'q', or <Esc>.")

  -- キー入力をリッスンする内部関数（再帰的に呼び出すことでループします）
  local function listen()
    -- ユーザーからのキー入力を1文字だけ待つ
    local char_code = vim.fn.getchar()
    -- getchar()は数値コードを返すので文字に変換します
    local key = vim.fn.nr2char(char_code)

    if key == 'n' then
      vim.diagnostic.goto_next()
      listen() -- 次の入力を待つために自分自身を呼び出す
    elseif key == 'N' then
      vim.diagnostic.goto_prev()
      listen()                                                    -- 次の入力を待つ
    elseif key == 'q' or char_code == 27 or char_code == 13 then  -- 'q'キー または Escキー(ASCIIコード 27)
      print("Exited diagnostic navigation mode.")
      vim.cmd('redraw')                                           -- コマンドラインのメッセージをクリア
      return                                                      -- ループを終了
    else
      -- n, N, q, Esc 以外のキーが押された場合は、モードを継続して次の入力を待つ
      listen()
    end
  end

  -- 最初のリスナーを起動
  listen()
end

-- ユーザーが呼び出すための :ModeError コマンドを作成
vim.api.nvim_create_user_command(
  'ModeError',
  start_diagnostic_listener,
  {
    nargs = 0, -- コマンドは引数を取らない
    desc = "Enter a temporary mode to navigate diagnostics with 'n' and 'N'"
  }
)
