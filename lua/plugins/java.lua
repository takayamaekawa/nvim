-- Java開発方法の切り替えフラグ (true: coc-java, false: nvim-java + jdtls)
local USE_COC_JAVA = true

-- coc-javaを使う場合はnvim-javaを無効化
if USE_COC_JAVA then
  return {}
else
  return { 'nvim-java/nvim-java' }
end

