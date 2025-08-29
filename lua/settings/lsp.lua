-- Java開発方法の切り替えフラグ (true: coc-java, false: nvim-java + jdtls)
local USE_COC_JAVA = false

-- if you fail to install jdtls, try to do :MasonInstall lombok-nightly
local servers_to_ensure = {
  "lua_ls", "bashls", "clangd", "ts_ls", "jsonls",
  "pyright", "html", "dockerls", "rust_analyzer", "powershell_es",
  -- "phpactor"
  "intelephense", "kotlin_language_server", "prismals"
}

-- coc-javaを使わない場合のみjdtlsを追加
if not USE_COC_JAVA then
  table.insert(servers_to_ensure, "jdtls")
end

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = servers_to_ensure,
  automatic_installation = false,
})

require("mason-conform").setup({
  ignore_install = {
    -- "prettier",
  }
})

-- coc-javaを使わない場合のみjava setupを実行
if not USE_COC_JAVA then
  require("java").setup()
end

require("neodev").setup()

-- you have to set [server_name].lua at lsp/ or after/lsp
-- I recommend you use that of files provided by neovim/nvim-lspconfig
-- If you use them, you can run ~/.config/nvim/lsp.sh
vim.lsp.enable(servers_to_ensure)

vim.lsp.config('*', {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  -- on_attach = require("settings.keymaps.lsp").on_attach
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    source = "always",
  },
})
