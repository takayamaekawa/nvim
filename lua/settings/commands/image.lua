local function setup_image_buffer()
  local file_path = vim.fn.expand('%:p')
  local file_name = vim.fn.expand('%:t')
  local file_ext = vim.fn.expand('%:e'):lower()
  
  local supported_formats = {
    'png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp', 'tiff', 'tif', 'svg'
  }
  
  local is_supported = false
  for _, ext in ipairs(supported_formats) do
    if file_ext == ext then
      is_supported = true
      break
    end
  end
  
  if is_supported then
    -- バッファの内容をクリアして読み取り専用にする
    vim.api.nvim_buf_set_option(0, 'modifiable', true)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
    
    -- 画像表示用のメッセージを表示
    local lines = {
      "# Image File: " .. file_name,
      "",
      "File path: " .. file_path,
      "",
      "Options to display image:",
      "1. :ShowImageKitty  - Try kitty icat (may not work from nvim)",
      "2. :ShowImageOpen   - Open with macOS default viewer",
      "3. :ShowImagePreview- Open with Preview.app",
      "",
      "Keymaps:",
      "<leader>ik - kitty icat",
      "<leader>io - default viewer", 
      "<leader>ip - Preview.app",
      "",
      ":q - Close this buffer"
    }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    
    -- バッファ設定
    vim.api.nvim_buf_set_option(0, 'modifiable', false)
    vim.api.nvim_buf_set_option(0, 'readonly', true)
    vim.api.nvim_buf_set_option(0, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(0, 'filetype', 'image')
    
    -- 自動的にデフォルトビューアーで画像を開く
    vim.schedule(function()
      local result = vim.fn.system('open "' .. file_path .. '"')
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to open image: " .. result, vim.log.levels.ERROR)
      end
    end)
  end
end

-- Kitty icat経由で画像表示を試す
local function show_image_with_kitty()
  local file_path = vim.fn.expand('%:p')
  local result = vim.fn.system('kitty +kitten icat "' .. file_path .. '" 2>&1')
  if vim.v.shell_error ~= 0 then
    vim.notify("Kitty icat failed: " .. result, vim.log.levels.WARN)
    vim.notify("Trying alternative method...", vim.log.levels.INFO)
    show_image_with_open()
  else
    vim.notify("Image displayed with kitty icat", vim.log.levels.INFO)
  end
end

-- macOSのopenコマンドでデフォルトビューアーを使用
local function show_image_with_open()
  local file_path = vim.fn.expand('%:p')
  local result = vim.fn.system('open "' .. file_path .. '"')
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to open image: " .. result, vim.log.levels.ERROR)
  else
    vim.notify("Image opened with default viewer", vim.log.levels.INFO)
  end
end

-- Preview.appで明示的に開く
local function show_image_with_preview()
  local file_path = vim.fn.expand('%:p')
  local result = vim.fn.system('open -a Preview "' .. file_path .. '"')
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to open with Preview: " .. result, vim.log.levels.ERROR)
  else
    vim.notify("Image opened with Preview.app", vim.log.levels.INFO)
  end
end

-- AutoCmdの設定
vim.api.nvim_create_autocmd({"BufReadPost"}, {
  pattern = {"*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.bmp", "*.tiff", "*.tif", "*.svg"},
  callback = setup_image_buffer,
  desc = "Setup image buffer and display image"
})

-- コマンドの定義
vim.api.nvim_create_user_command('ShowImageKitty', show_image_with_kitty, {
  desc = "Display current image file using kitty icat"
})

vim.api.nvim_create_user_command('ShowImageOpen', show_image_with_open, {
  desc = "Display current image file using default viewer"
})

vim.api.nvim_create_user_command('ShowImagePreview', show_image_with_preview, {
  desc = "Display current image file using Preview.app"
})

-- 後方互換性のため
vim.api.nvim_create_user_command('ShowImage', show_image_with_kitty, {
  desc = "Display current image file using kitty icat (fallback to default viewer)"
})

-- 画像ファイル用のキーマップ（画像バッファでのみ有効）
vim.api.nvim_create_autocmd("FileType", {
  pattern = "image",
  callback = function()
    local opts = { buffer = true, silent = true }
    vim.keymap.set('n', '<leader>ik', show_image_with_kitty, 
      vim.tbl_extend('force', opts, { desc = "Show image with kitty icat" }))
    vim.keymap.set('n', '<leader>io', show_image_with_open, 
      vim.tbl_extend('force', opts, { desc = "Show image with default viewer" }))
    vim.keymap.set('n', '<leader>ip', show_image_with_preview, 
      vim.tbl_extend('force', opts, { desc = "Show image with Preview.app" }))
  end,
})