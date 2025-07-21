local dap, dapui = require("dap"), require("dapui")
local install_root_dir = vim.fn.stdpath("data") .. "/mason"
local extension_path = install_root_dir .. "/packages/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local config = require("configHandler").get

dap.adapters.java = function(callback)
  -- Java Debug Server のポートを指定
  callback({
    type = 'server',
    host = '127.0.0.1',
    port = 5005
  })
end

local classpaths = {}
-- もし、configがあれば、classpathsに追加
if config and config.self and config.self.java and config.self.java.classpaths then
  for _, path in ipairs(config.self.java.classpaths) do
    table.insert(classpaths, path)
  end
end

dap.configurations.java = {
  {
    name = '[kishax] Java: Debug Current File: Launch',
    type = 'java',
    request = 'launch',
    mainClass = '${file}',
    projectName = "kishax",
    classPaths = classpaths,
  },
  {
    name = '[kishax] Java: Debug Current File: Attach',
    type = 'java',
    request = 'attach',
    mainClass = '${file}',
    projectName = "kishax",
    classPaths = classpaths,
  },
}

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = codelldb_path,
    args = { "--port", "${port}" },
  },
}

dap.configurations.c = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("実行可能ファイルのパス: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = true,
  },
}

dap.configurations.cpp = dap.configurations.c

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

-- open_on_attach = true,
-- open_on_launch = true,

dapui.setup({})

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
-- dap.listeners.before.event_terminated.dapui_config = function()
--     dapui.close()
-- end
-- dap.listeners.before.event_exited.dapui_config = function()
--     dapui.close()
-- end
