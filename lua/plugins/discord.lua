return {
  'vyfor/cord.nvim',
  -- build = ':Cord update', -- buildは初回のみでOKなので、毎回実行する必要がなければコメントアウトしても良い

  -- lazy.nvimの 'cond' オプションを使用
  -- この関数がtrueを返す場合のみ、プラグインが読み込まれる
  cond = function()
    -- Windows環境でのみ有効なチェック
    -- Discordが起動してRPCの準備ができると作成される名前付きパイプの存在を確認
    -- vim.fn.filereadable() はファイルが読み込み可能なら1(true)を返す
    if vim.fn.has('win32') or vim.fn.has('win64') then
      return vim.fn.filereadable('//./pipe/discord-ipc-0') == 1
    end
    -- Linuxネイティブなど、他の環境では常に無効化
    return false
  end,

  -- プラグインが読み込まれた場合の設定
  opts = {
    -- ここにcord.nvimの通常の設定を記述
  }
}
