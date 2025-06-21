return {
  'vyfor/cord.nvim',
  -- build = ':Cord update', -- buildは初回のみでOK

  cond = function()
    -- 条件1: 環境がWindowsネイティブまたはWSLの場合
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 or os.getenv('WSL_DISTRO_NAME') ~= nil then
      -- Windowsの名前付きパイプの存在を確認して終了
      return vim.fn.filereadable('//./pipe/discord-ipc-0') == 1
    end

    -- 条件2: 環境がLinuxまたはmacOSの場合
    -- discord-ipc-0 から discord-ipc-9 までを順番に検索する
    for i = 0, 9 do
      local suffix = 'discord-ipc-' .. i
      local xdg_runtime_dir = os.getenv('XDG_RUNTIME_DIR')

      -- 検索するパスのリスト（優先順位順）
      local potential_paths = {
        -- Flatpak版Discordのパス
        xdg_runtime_dir and (xdg_runtime_dir .. '/app/com.discordapp.Discord/' .. suffix),
        -- 標準的なXDGパス
        xdg_runtime_dir and (xdg_runtime_dir .. '/' .. suffix),
        -- フォールバック用の/tmpパス
        '/tmp/' .. suffix,
      }

      -- 各パスの存在をチェック
      for _, path in ipairs(potential_paths) do
        if path then
          -- filereadable()はソケットに機能しないことがあるため、glob()で存在確認するのが確実
          if vim.fn.empty(vim.fn.glob(path)) == 0 then
            return true -- 発見したら、その時点でtrueを返して終了
          end
        end
      end
    end

    -- どの条件にも一致しなかった場合
    return false
  end,

  opts = {
    -- ここにcord.nvimの通常の設定を記述
  }
}
