require("config.lazy")
require("settings")

require('bufferline').setup({})

require("settings.overseer")
require("settings.toggleterm")

require("settings.keymaps")
require("ibl").setup({
  indent = {
    char = "|",
  },
})
require("settings.conform")
