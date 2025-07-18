-- OSC 52 clipboard support for SSH/Remote environments
-- This module provides clipboard functionality over SSH using OSC 52 escape sequences

local M = {}

-- Check if we're in an SSH environment
local function is_ssh_env()
  return os.getenv('SSH_CLIENT') ~= nil or 
         os.getenv('SSH_TTY') ~= nil or 
         os.getenv('SSH_CONNECTION') ~= nil
end

-- Check if we're in WSL
local function is_wsl_env()
  return os.getenv('WSL_DISTRO_NAME') ~= nil or
         vim.fn.has('win32') == 1 or
         vim.fn.has('win64') == 1
end

-- OSC 52 copy function
local function osc52_copy(text)
  local encoded = vim.fn.system('base64 -w 0', text):gsub('\n', '')
  local osc52 = string.format('\027]52;c;%s\007', encoded)
  
  -- Write to /dev/tty to bypass any terminal multiplexer
  local handle = io.open('/dev/tty', 'w')
  if handle then
    handle:write(osc52)
    handle:close()
  end
end

-- Setup clipboard for different environments
function M.setup()
  if is_wsl_env() then
    -- WSL environment - use win32yank
    if vim.fn.executable('win32yank.exe') == 1 then
      vim.g.clipboard = {
        name = 'win32yank-wsl',
        copy = {
          ['+'] = 'win32yank.exe -i --crlf',
          ['*'] = 'win32yank.exe -i --crlf',
        },
        paste = {
          ['+'] = 'win32yank.exe -o --lf',
          ['*'] = 'win32yank.exe -o --lf',
        },
        cache_enabled = 0,
      }
    end
  elseif is_ssh_env() then
    -- SSH environment - use OSC 52
    vim.g.clipboard = {
      name = 'osc52',
      copy = {
        ['+'] = function(lines)
          osc52_copy(table.concat(lines, '\n'))
        end,
        ['*'] = function(lines)
          osc52_copy(table.concat(lines, '\n'))
        end,
      },
      paste = {
        ['+'] = function()
          -- OSC 52 doesn't support paste, return empty
          return {''}
        end,
        ['*'] = function()
          -- OSC 52 doesn't support paste, return empty
          return {''}
        end,
      },
    }
    
    -- Auto-copy on yank
    vim.api.nvim_create_autocmd('TextYankPost', {
      group = vim.api.nvim_create_augroup('OSC52Yank', { clear = true }),
      callback = function()
        if vim.v.event.operator == 'y' then
          osc52_copy(vim.fn.getreg('"'))
        end
      end,
    })
  else
    -- Standard environment - use system clipboard
    vim.opt.clipboard = 'unnamedplus'
  end
end

-- Manual OSC 52 copy command
function M.copy_to_osc52(text)
  if text then
    osc52_copy(text)
  else
    osc52_copy(vim.fn.getreg('"'))
  end
end

-- Create user commands
vim.api.nvim_create_user_command('OSC52Copy', function()
  M.copy_to_osc52()
end, { desc = 'Copy current register to OSC 52' })

vim.api.nvim_create_user_command('OSC52CopyRange', function(opts)
  local start_line = opts.line1
  local end_line = opts.line2
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, '\n')
  M.copy_to_osc52(text)
end, { range = true, desc = 'Copy range to OSC 52' })

-- Initialize OSC 52 clipboard support
M.setup()

return M