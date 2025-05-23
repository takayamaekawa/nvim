-- if you fail to install jdtls, try to do :MasonInstall lombok-nightly
local servers_to_ensure = {
  "lua_ls", "bashls", "clangd", "ts_ls", "jdtls", "jsonls",
  "pyright", "html", "dockerls", "rust_analyzer", "powershell_es",
  "phpactor"
}

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = servers_to_ensure,
  automatic_installation = false,
})

require("mason-conform").setup({
  ignore_install = {
    "prettier",
  }
})

require("java").setup()
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
