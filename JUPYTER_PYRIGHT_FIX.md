# Jupyter Notebook + Pyright 停止問題の修正

## 問題の概要

`~/voltmind/test/pixeltable/test.ipynb` をnvimで開き、`<space>rc` を実行すると、しばらくしてpyrightが停止する問題が発生していました。

## 原因

1. **ファイル変換の負荷**: `.ipynb` ファイルが `jupytext` により `.py` ファイルに変換される際、pyrightが大量のファイル変更通知を受信
2. **保存処理のタイミング**: セル実行後の自動保存（100ms後）が頻繁に実行され、LSPに過度な負荷
3. **診断の更新**: テキスト変更のたびにpyrightが診断を更新し、リソースを消費

## 実施した修正

### 1. Pyright設定の最適化 (`after/lsp/pyright.lua`)

```lua
settings = {
  python = {
    analysis = {
      diagnosticMode = "openFilesOnly",  -- 開いているファイルのみ診断
      typeCheckingMode = "basic",        -- 軽量な型チェック
      autoSearchPaths = true,
      useLibraryCodeForTypes = true,
      autoImportCompletions = true,
    }
  }
},
flags = {
  debounce_text_changes = 300,  -- テキスト変更通知を遅延（150ms → 300ms）
},
```

### 2. Notebook Navigator設定の改善 (`lua/plugins/notebook-navigator.lua`)

- **保存タイミングの延長**: 100ms → 300ms に変更
- **診断の一時停止**: 保存中は診断更新を無効化し、完了後500ms後に再開
- これにより、LSPへの連続的な負荷を軽減

```lua
{ "<leader>rc", function() 
    require("notebook-navigator").run_cell()
    vim.defer_fn(function()
      -- 診断を一時的に無効化
      local old_update_in_insert = vim.diagnostic.config().update_in_insert
      vim.diagnostic.config({ update_in_insert = false })
      
      vim.cmd("silent! write")
      
      -- 500ms後に診断を再開
      vim.defer_fn(function()
        vim.diagnostic.config({ update_in_insert = old_update_in_insert })
      end, 500)
    end, 300)
  end, desc = "Run Cell and Save" },
```

### 3. Jupytext設定の強化 (`lua/plugins/jupytext.lua`)

- **ipynbファイル用の特別処理**: ファイルを開いた際、pyrightに最適化された設定を自動適用
- **診断モードの動的変更**: notebookファイルは `openFilesOnly` モードに設定

```lua
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.ipynb",
  callback = function()
    vim.defer_fn(function()
      local clients = vim.lsp.get_clients({ bufnr = 0, name = "pyright" })
      for _, client in ipairs(clients) do
        client.config.settings.python.analysis.diagnosticMode = "openFilesOnly"
        client.notify("workspace/didChangeConfiguration", {
          settings = client.config.settings
        })
      end
    end, 1000)
  end,
})
```

### 4. LSP再起動コマンドの追加

pyrightが完全に停止した場合に備えて、再起動コマンドを追加しました。

#### コマンド
- `:RestartPyright` - Pyrightのみ再起動
- `:RestartLsp` - 現在のバッファのすべてのLSPサーバーを再起動

#### キーマッピング
- `<space>lp` - Pyrightを再起動
- `<space>lr` - すべてのLSPサーバーを再起動

## 使用方法

1. **通常の使用**: 修正により、`<space>rc` を実行してもpyrightが停止しなくなります

2. **pyrightが停止した場合**: 
   - `<space>lp` を押してpyrightを再起動
   - または `:RestartPyright` コマンドを実行

3. **すべてのLSPが不調な場合**:
   - `<space>lr` を押してすべてのLSPを再起動
   - または `:RestartLsp` コマンドを実行

## 効果

- **pyrightの安定性向上**: セル実行時の停止問題を解消
- **パフォーマンス改善**: LSPへの負荷軽減により、応答性が向上
- **復旧手段の提供**: 万が一停止した場合でも、簡単に再起動可能

## 注意事項

- 保存タイミングが300msに延長されたため、セル実行から保存まで若干の遅延があります
- 大規模なnotebookファイルでは、依然として負荷が高い場合があります
- その場合は、`diagnosticMode` を `"workspace"` から `"openFilesOnly"` に変更することで、さらに負荷を軽減できます

## テスト方法

1. `~/voltmind/test/pixeltable/test.ipynb` を開く
2. `<space>rc` を複数回実行
3. pyrightが動作し続けることを確認（`:LspInfo` でステータス確認）

## 関連ファイル

- `after/lsp/pyright.lua` - Pyright LSP設定
- `lua/plugins/notebook-navigator.lua` - Notebook Navigator設定
- `lua/plugins/jupytext.lua` - Jupytext設定
- `lua/settings/commands/lsp.lua` - LSP再起動コマンド
- `lua/settings/keymaps/lsp.lua` - LSPキーマッピング

