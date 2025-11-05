-- Markdown specific settings and keymaps

-- ============================================================================
-- Auto-numbering for ordered lists with Ctrl+Enter
-- ============================================================================

-- Function to insert next numbered list item
local function insert_next_number()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  
  -- Match numbered list pattern: optional spaces, number, dot, space
  local indent, num = line:match("^(%s*)(%d+)%.")
  
  if indent and num then
    local next_num = tonumber(num) + 1
    local new_line = indent .. next_num .. ". "
    
    -- Insert new line below current line
    vim.api.nvim_buf_set_lines(0, row, row, false, {""})
    vim.api.nvim_win_set_cursor(0, {row + 1, 0})
    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, {row + 1, #new_line})
  else
    -- If not in a numbered list, just insert a new line
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
  end
end

-- Map Ctrl+Enter in Insert mode
vim.keymap.set("i", "<C-CR>", insert_next_number, { buffer = true, silent = true, desc = "Insert next numbered list item" })

-- ============================================================================
-- TAB/SHIFT-TAB for indenting and renumbering lists
-- ============================================================================

-- Function to renumber all items in current list block
local function renumber_list_block(start_line)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local current_indent = nil
  local counter = 1
  
  for i = start_line, #lines do
    local line = lines[i]
    local indent, num = line:match("^(%s*)(%d+)%.")
    
    if indent and num then
      if current_indent == nil then
        current_indent = #indent
      end
      
      if #indent == current_indent then
        -- Renumber this line
        local rest = line:match("^%s*%d+%.(.*)$")
        local new_line = indent .. counter .. "." .. rest
        vim.api.nvim_buf_set_lines(0, i - 1, i, false, {new_line})
        counter = counter + 1
      elseif #indent < current_indent then
        -- Reached a parent level, stop renumbering
        break
      end
      -- If indent > current_indent, skip (child items)
    elseif not line:match("^%s*$") then
      -- Non-empty, non-list line, stop renumbering
      break
    end
    -- Empty line continues the block (do nothing)
  end
end

-- Function to indent current line and renumber
local function indent_and_renumber()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  
  -- Check if current line is a numbered list
  local indent, num = line:match("^(%s*)(%d+)%.")
  
  if indent and num then
    -- Add indent (2 spaces)
    local new_line = "  " .. line
    vim.api.nvim_set_current_line(new_line)
    
    -- Move cursor to maintain position
    local col = vim.api.nvim_win_get_cursor(0)[2]
    vim.api.nvim_win_set_cursor(0, {row, col + 2})
    
    -- Find the start of this list block and renumber
    local start_line = row
    for i = row - 1, 1, -1 do
      local prev_line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
      local prev_indent, prev_num = prev_line:match("^(%s*)(%d+)%.")
      if prev_indent and prev_num and #prev_indent <= #indent then
        start_line = i
      else
        break
      end
    end
    renumber_list_block(start_line)
  else
    -- Normal tab behavior
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end

-- Function to dedent current line and renumber
local function dedent_and_renumber()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  
  -- Check if current line is a numbered list
  local indent, num = line:match("^(%s*)(%d+)%.")
  
  if indent and num and #indent >= 2 then
    -- Remove indent (2 spaces)
    local new_line = line:sub(3)
    vim.api.nvim_set_current_line(new_line)
    
    -- Move cursor to maintain position
    local col = vim.api.nvim_win_get_cursor(0)[2]
    vim.api.nvim_win_set_cursor(0, {row, math.max(0, col - 2)})
    
    -- Find the start of this list block and renumber
    local start_line = row
    local new_indent = #indent - 2
    for i = row - 1, 1, -1 do
      local prev_line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
      local prev_indent, prev_num = prev_line:match("^(%s*)(%d+)%.")
      if prev_indent and prev_num and #prev_indent <= new_indent then
        start_line = i
      else
        break
      end
    end
    renumber_list_block(start_line)
  else
    -- Normal shift-tab behavior (dedent)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, false, true), "n", false)
  end
end

-- Map TAB and SHIFT-TAB in Insert mode
vim.keymap.set("i", "<Tab>", function()
  local line = vim.api.nvim_get_current_line()
  local indent, num = line:match("^(%s*)(%d+)%.")
  if indent and num then
    indent_and_renumber()
  else
    -- Normal tab behavior - insert actual tab or spaces
    return "<Tab>"
  end
end, { buffer = true, silent = true, expr = true, desc = "Indent and renumber list" })

vim.keymap.set("i", "<S-Tab>", function()
  local line = vim.api.nvim_get_current_line()
  local indent, num = line:match("^(%s*)(%d+)%.")
  if indent and num then
    dedent_and_renumber()
  else
    -- Normal shift-tab behavior
    return "<C-d>"
  end
end, { buffer = true, silent = true, expr = true, desc = "Dedent and renumber list" })

-- Also map in Normal mode for convenience
vim.keymap.set("n", "<Tab>", function()
  local line = vim.api.nvim_get_current_line()
  local indent, num = line:match("^(%s*)(%d+)%.")
  if indent and num then
    indent_and_renumber()
  else
    -- Normal behavior: indent the line
    vim.cmd("normal! >>")
  end
end, { buffer = true, silent = true, desc = "Indent and renumber list" })

vim.keymap.set("n", "<S-Tab>", function()
  local line = vim.api.nvim_get_current_line()
  local indent, num = line:match("^(%s*)(%d+)%.")
  if indent and num then
    dedent_and_renumber()
  else
    -- Normal behavior: dedent the line
    vim.cmd("normal! <<")
  end
end, { buffer = true, silent = true, desc = "Dedent and renumber list" })
