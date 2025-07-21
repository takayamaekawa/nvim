local debugText = [[]]

local function addDebugText(text)
  debugText = debugText .. "\n" .. text
end

local config = require("configHandler").get

if not config then
  addDebugText("No configuration found.")
  return
end

if config.self and config.self.debug then
  addDebugText("Debug mode is enabled.")
  if config and config.plugins and config.plugins.obsidian and config.plugins.obsidian.workspaces then
    for _, workspace in ipairs(config.plugins.obsidian.workspaces) do
      addDebugText("Workspace Name: " .. workspace.name)
      addDebugText("Workspace Path: " .. workspace.path)
    end
  else
    addDebugText("No workspaces found in the configuration.")
  end

  -- config.self.workspacesがあればそれをaddDebugTextする
  if config and config.self and config.self.workspaces then
    for _, workspace in ipairs(config.self.workspaces) do
      addDebugText("Self Workspace Name: " .. workspace.name)
      addDebugText("Self Workspace Path: " .. workspace.path)
      if workspace.comment then
        addDebugText("Comment: " .. workspace.comment)
      end
    end
  else
    addDebugText("No self workspaces found in the configuration.")
  end

  -- config.self.javaがあればそれをaddDebugTextする
  if config and config.self and config.self.java and config.self.java.classpaths then
    addDebugText("Java Classpaths:")
    for _, path in ipairs(config.self.java.classpaths) do
      addDebugText(" - " .. path)
    end
  else
    addDebugText("No Java classpath found in the configuration.")
  end
end

if debugText ~= "" then
  vim.notify(debugText, vim.log.levels.INFO)
end
