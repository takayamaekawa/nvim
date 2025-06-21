return {
  'vyfor/cord.nvim',
  -- build = ':Cord update',

  cond = function()
    -- 条件1: 環境がWindowsネイティブの場合
    -- (WSLの場合は、socatコマンドによるnpiperelay.exeにより、パイプファイルをリレーするため、ここでは除外する
    -- WSL環境を検出するには: os.getenv('WSL_DISTRO_NAME') ~= nil)
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
      -- discord-ipc-0 から 9 までを順番に検索
      for i = 0, 9 do
        local pipe_path = '//./pipe/discord-ipc-' .. i

        -- 【変更点】filereadable() から glob()での存在チェックに変更
        if vim.fn.empty(vim.fn.glob(pipe_path)) == 0 then
          -- print("Found Discord pipe on Windows/WSL: " .. pipe_path) -- デバッグしたい場合はこの行を有効化
          return true -- 発見したら、その時点でtrueを返す
        end
      end
      -- 0から9まで見つからなかった場合
      return false
    end

    -- 条件2: 環境がLinuxまたはmacOSの場合
    for i = 0, 9 do
      local suffix = 'discord-ipc-' .. i
      local xdg_runtime_dir = os.getenv('XDG_RUNTIME_DIR')
      local potential_paths = {
        xdg_runtime_dir and (xdg_runtime_dir .. '/app/com.discordapp.Discord/' .. suffix),
        xdg_runtime_dir and (xdg_runtime_dir .. '/' .. suffix),
        '/tmp/' .. suffix,
      }
      for _, path in ipairs(potential_paths) do
        if path and vim.fn.empty(vim.fn.glob(path)) == 0 then
          return true
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
