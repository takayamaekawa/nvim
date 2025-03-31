local M = {}

local notify = require("notify")

local notifications = {}

-- extends notify.notify function
local original_notify = notify.notify
notify.notify = function(msg, ...)
  table.insert(notifications, msg)
  return original_notify(msg, ...)
end

function M.copy_notifications_to_clipboard()
  local all_notifications = table.concat(notifications, "\n")
  vim.fn.setreg("+", all_notifications)
  vim.notify("Copied all notifications.")
end

-- vim.api.nvim_set_hl(0, "NotifyBackground", { link = "NormalFloat" })

vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000" }) -- または "#000000"

notify.setup({
  background_colour = "#000000",
  -- render = "minimal",
  stages = "fade_in_slide_out",
  position = "bottom-right",
  timeout = 3000,
  animation_speed = 100,
  border = "rounded",

  -- ログレベル (debug, info, warn, error)
  -- level = "info",
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
  top_down = false,
})

vim.notify = notify

require('telescope').load_extension('notify')

return M
