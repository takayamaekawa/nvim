vim.lsp.config('*', {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  on_attach = require("settings.keymaps.lsp").on_attach
})

require("mason").setup()

-- if you fail to install jdtls, try to do :MasonInstall lombok-nightly
local servers_to_ensure = {
  "lua_ls", "bashls", "clangd", "ts_ls", "jdtls", "jsonls",
  "pyright", "html", "dockerls", "rust_analyzer", "powershell_es",
}

require("mason-lspconfig").setup({
  ensure_installed = servers_to_ensure,
  automatic_installation = true,
})

if vim.tbl_contains(servers_to_ensure, "jdtls") then
  local java_ok, java = pcall(require, "java")
  if java_ok then
    java.setup()
  else
    vim.notify("[LSP] nvim-java could not be loaded.", vim.log.levels.WARN)
  end
end

require("neodev").setup({})

vim.lsp.enable(servers_to_ensure)

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
