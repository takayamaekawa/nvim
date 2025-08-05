-- COC全体の切り替えフラグ (true: COC使用, false: LSP直接使用)
local USE_COC = false

-- COCを使う場合はnvim-javaを無効化
if USE_COC then
  return {}
else
  return { 'nvim-java/nvim-java' }
end
