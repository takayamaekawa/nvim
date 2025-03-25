return {
  "Shatur/neovim-session-manager",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("settings.session-manager").setup()
  end,
}
