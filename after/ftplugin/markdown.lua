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

-- Map Shift+Enter in Insert mode
vim.keymap.set("i", "<S-CR>", insert_next_number, { buffer = true, silent = true, desc = "Insert next numbered list item" })

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
  vim.schedule(function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_get_current_line()
    
    -- Check if current line is a numbered list
    local indent, num = line:match("^(%s*)(%d+)%.")
    
    if indent and num then
      local old_indent_len = #indent
      local new_indent_len = old_indent_len + 2
      
      -- Calculate the correct number for the new indent level
      -- Look backward for the last item with the same new indent level
      -- Skip items that are between old and new indent levels
      local new_num = 1
      for i = row - 1, 1, -1 do
        local prev_line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
        local prev_indent, prev_num = prev_line:match("^(%s*)(%d+)%.")
        if prev_indent and prev_num then
          local prev_indent_len = #prev_indent
          if prev_indent_len == new_indent_len then
            -- Found an item at the same new indent level
            new_num = tonumber(prev_num) + 1
            break
          elseif prev_indent_len < new_indent_len and prev_indent_len >= old_indent_len then
            -- Found a parent level or same old level, start from 1
            break
          elseif prev_indent_len < old_indent_len then
            -- Found a shallower level than old indent, start from 1
            break
          end
          -- If prev_indent_len > new_indent_len, skip (deeper items)
        elseif not prev_line:match("^%s*$") then
          -- Non-list line, stop searching
          break
        end
      end
      
      -- Add indent and update number
      local rest = line:match("^%s*%d+%.(.*)$")
      local new_line = string.rep(" ", new_indent_len) .. new_num .. "." .. rest
      vim.api.nvim_set_current_line(new_line)
      
      -- Move cursor to maintain relative position
      local col = vim.api.nvim_win_get_cursor(0)[2]
      vim.api.nvim_win_set_cursor(0, {row, col + 2})
      
      -- Renumber following items at the new indent level (only items after current line)
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local counter = new_num + 1
      for i = row + 1, #lines do
        local next_line = lines[i]
        local next_indent, next_num = next_line:match("^(%s*)(%d+)%.")
        if next_indent and next_num then
          local next_indent_len = #next_indent
          if next_indent_len == new_indent_len then
            -- Renumber this line
            local rest_text = next_line:match("^%s*%d+%.(.*)$")
            local updated_line = string.rep(" ", new_indent_len) .. counter .. "." .. rest_text
            vim.api.nvim_buf_set_lines(0, i - 1, i, false, {updated_line})
            counter = counter + 1
          elseif next_indent_len < new_indent_len then
            -- Reached a shallower level, stop
            break
          end
          -- If deeper, skip (child items)
        elseif not next_line:match("^%s*$") then
          -- Non-list line, stop
          break
        end
      end
    end
  end)
end

-- Function to dedent current line and renumber
local function dedent_and_renumber()
  vim.schedule(function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_get_current_line()
    
    -- Check if current line is a numbered list
    local indent, num = line:match("^(%s*)(%d+)%.")
    
    if indent and num and #indent >= 2 then
      local old_indent_len = #indent
      local new_indent_len = old_indent_len - 2
      
      -- Calculate the correct number for the new indent level
      -- We need to find where this item belongs in the parent level
      -- Strategy: Look backward and skip all items that are deeper or equal to old indent
      local new_num = 1
      local found_parent = false
      
      -- Debug output
      -- vim.notify(string.format("SHIFT-TAB Debug: row=%d, old_indent=%d, new_indent=%d", 
      --                          row, old_indent_len, new_indent_len), vim.log.levels.INFO)
      
      for i = row - 1, 1, -1 do
        local prev_line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
        local prev_indent, prev_num = prev_line:match("^(%s*)(%d+)%.")
        if prev_indent and prev_num then
          local prev_indent_len = #prev_indent
          -- Debug output
          -- vim.notify(string.format("  Line %d: indent=%d, num=%s (checking...)", 
          --                          i, prev_indent_len, prev_num), vim.log.levels.INFO)
          
          -- Skip items that are deeper or at the same level as the old indent
          -- (these are siblings or children at the old level)
          if prev_indent_len >= old_indent_len then
            -- Skip this line, continue searching
            -- vim.notify(string.format("    -> SKIP (indent >= %d)", old_indent_len), vim.log.levels.INFO)
          elseif prev_indent_len == new_indent_len then
            -- Found an item at the target (parent) level
            new_num = tonumber(prev_num) + 1
            found_parent = true
            -- vim.notify(string.format("    -> FOUND! new_num = %d", new_num), vim.log.levels.INFO)
            break
          elseif prev_indent_len < new_indent_len then
            -- Found a shallower level than target, start from 1
            -- vim.notify(string.format("    -> SHALLOWER, new_num = 1"), vim.log.levels.INFO)
            break
          end
        elseif not prev_line:match("^%s*$") then
          -- Non-list line, stop searching
          -- vim.notify("    -> Non-list line, stopping", vim.log.levels.INFO)
          break
        end
      end
      
      -- vim.notify(string.format("Final new_num = %d", new_num), vim.log.levels.INFO)
      
      -- Remove indent and update number
      local rest = line:match("^%s*%d+%.(.*)$")
      local new_line = string.rep(" ", new_indent_len) .. new_num .. "." .. rest
      vim.api.nvim_set_current_line(new_line)
      
      -- Move cursor to after "number. " (indent + number + period + space)
      local new_col = new_indent_len + #tostring(new_num) + 2  -- +2 for ". "
      vim.api.nvim_win_set_cursor(0, {row, new_col})
      
      -- Renumber following items at the new indent level (only items after current line)
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local counter = new_num + 1
      for i = row + 1, #lines do
        local next_line = lines[i]
        local next_indent, next_num = next_line:match("^(%s*)(%d+)%.")
        if next_indent and next_num then
          local next_indent_len = #next_indent
          if next_indent_len == new_indent_len then
            -- Renumber this line
            local rest_text = next_line:match("^%s*%d+%.(.*)$")
            local updated_line = string.rep(" ", new_indent_len) .. counter .. "." .. rest_text
            vim.api.nvim_buf_set_lines(0, i - 1, i, false, {updated_line})
            counter = counter + 1
          elseif next_indent_len < new_indent_len then
            -- Reached a shallower level, stop
            break
          end
          -- If deeper, skip (child items)
        elseif not next_line:match("^%s*$") then
          -- Non-list line, stop
          break
        end
      end
    end
  end)
end

-- Map TAB and SHIFT-TAB in Insert mode
vim.keymap.set("i", "<Tab>", function()
  local line = vim.api.nvim_get_current_line()
  local indent, num = line:match("^(%s*)(%d+)%.")
  if indent and num then
    indent_and_renumber()
  else
    -- Normal tab behavior - insert actual tab or spaces
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, { buffer = true, silent = true, desc = "Indent and renumber list" })

vim.keymap.set("i", "<S-Tab>", function()
  local line = vim.api.nvim_get_current_line()
  local indent, num = line:match("^(%s*)(%d+)%.")
  if indent and num then
    dedent_and_renumber()
  else
    -- Normal shift-tab behavior
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, false, true), "n", false)
  end
end, { buffer = true, silent = true, desc = "Dedent and renumber list" })

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
