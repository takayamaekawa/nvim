local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local configHandler = require("configHandler")
local config = configHandler.get

local M = {}

-- Python環境選択後のアクション
local function select_python_env(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)

  if selection then
    local env = selection.value
    
    -- config.jsonの active_python_env を更新
    if config and config.self then
      config.self.active_python_env = env.name
      local success = configHandler.update(config)
      
      if success then
        -- python3_host_prog を更新
        vim.g.python3_host_prog = env.path
        
        vim.notify(
          string.format('Python environment switched to: %s\n%s\nRestart Neovim to apply changes.',
            env.name,
            env.path
          ),
          vim.log.levels.INFO
        )
      else
        vim.notify('Failed to update config.json', vim.log.levels.ERROR)
      end
    end
  end
end

-- telescope pickerを作成
function M.show_python_envs()
  if not config or not config.self or not config.self.python_environments then
    vim.notify('No Python environments configured', vim.log.levels.ERROR)
    return
  end

  local python_envs = config.self.python_environments or {}

  if #python_envs == 0 then
    vim.notify('No Python environments found', vim.log.levels.WARN)
    return
  end

  local active_env = config.self.active_python_env or ""

  pickers.new({}, {
    prompt_title = 'Select Python Environment',
    finder = finders.new_table({
      results = python_envs,
      entry_maker = function(entry)
        local is_active = (entry.name == active_env)
        local marker = is_active and "[ACTIVE] " or ""
        
        local display_text = string.format(
          '%s%s - %s',
          marker,
          entry.name,
          entry.comment or 'No comment'
        )

        return {
          value = entry,
          display = display_text,
          ordinal = entry.name .. ' ' .. (entry.comment or ''),
          path = entry.path
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(select_python_env)
      return true
    end,
  }):find()
end

return M

