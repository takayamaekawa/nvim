local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local M = {}

-- プロジェクト情報を読み込む関数
local function load_workspaces()
  local config_path = vim.fn.stdpath('config') .. '/workspaces.json'

  -- ファイルが存在しない場合
  if vim.fn.filereadable(config_path) == 0 then
    vim.notify('workspaces.json not found at: ' .. config_path, vim.log.levels.ERROR)
    return {}
  end

  -- JSONファイルを読み込み
  local file = io.open(config_path, 'r')
  if not file then
    vim.notify('Failed to open workspaces.json', vim.log.levels.ERROR)
    return {}
  end

  local content = file:read('*all')
  file:close()

  -- JSONをパース
  local ok, workspaces_data = pcall(vim.json.decode, content)
  if not ok then
    vim.notify('Failed to parse workspaces.json', vim.log.levels.ERROR)
    return {}
  end

  return workspaces_data.workspaces or {}
end

-- プロジェクト選択後のアクション
local function select_workspaces(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)

  if selection then
    local workspaces = selection.value

    -- 新しいタブを作成
    vim.cmd('tabnew')

    -- プロジェクトディレクトリに移動
    vim.cmd('cd ' .. vim.fn.fnameescape(workspaces.path))

    -- NvimTreeを開く
    vim.cmd('NvimTreeOpen ' .. vim.fn.fnameescape(workspaces.path))

    vim.notify('Opened workspaces: ' .. workspaces.name, vim.log.levels.INFO)
  end
end

-- telescope pickerを作成
function M.show_workspaces()
  local workspaces = load_workspaces()

  if #workspaces == 0 then
    vim.notify('No workspaces found', vim.log.levels.WARN)
    return
  end

  pickers.new({}, {
    prompt_title = 'Select workspaces',
    finder = finders.new_table({
      results = workspaces,
      entry_maker = function(entry)
        local display_text = string.format(
          '%s - %s',
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
      actions.select_default:replace(select_workspaces)
      return true
    end,
  }):find()
end

return M
