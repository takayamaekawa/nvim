---@class ObsidianWorkspace
---@field name string
---@field path string

---@class SelfWorkspace
---@field name string
---@field path string
---@field comment string

---@class ObsidianConfig
---@field workspaces ObsidianWorkspace[]

---@class PluginsTable
---@field obsidian ObsidianConfig

---@class SelfJavaConfig
---@field classpaths string[]

---@class PythonEnvironment
---@field name string
---@field path string
---@field comment string

---@class SelfTable
---@field debug boolean
---@field python_environments PythonEnvironment[]
---@field active_python_env string
---@field workspaces SelfWorkspace[]
---@field java SelfJavaConfig

---@class Config
---@field plugins PluginsTable
---@field self SelfTable

local M = {}

-- data/config.jsonがなければ、data/config.json.exampleを読み取る
-- もしdata/config.jsonが存在しない場合は、data/config.json.exampleはコピーせず、それを読み込むようにする
local plugins_config_path = vim.fn.stdpath('config') .. '/data/config.json'
local example_config_path = vim.fn.stdpath('config') .. '/data/config.json.example'
if not vim.loop.fs_stat(plugins_config_path) then
  if vim.loop.fs_stat(example_config_path) then
    local example_content = vim.fn.readfile(example_config_path)
    vim.fn.writefile(example_content, plugins_config_path)
  else
    -- If the example config does not exist, create an empty config file
    vim.fn.writefile({}, plugins_config_path)
  end
end

---@return Config|nil
local function load_config()
  local file = io.open(plugins_config_path, 'r')
  if not file then return nil end
  local content = file:read('*all')
  file:close()
  local ok, config = pcall(vim.json.decode, content)
  if ok then
    return config
  end
  return nil
end

M.get = load_config()
M.getpath = plugins_config_path

-- 実行中に、configを更新するための関数
---@return boolean success
---@param new_config Config
function M.update(new_config)
  local json_content = vim.json.encode(new_config, { indent = true })
  local file = io.open(plugins_config_path, 'w')
  if file then
    file:write(json_content)
    file:close()
    vim.cmd('edit ' .. plugins_config_path)
    vim.lsp.buf.format({ async = false })
    vim.cmd('write')
    M.get = load_config()
  else
    vim.notify("Failed to write config.json", vim.log.levels.ERROR)
    return false
  end

  return true
end

return M
