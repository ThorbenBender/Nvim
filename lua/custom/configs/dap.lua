local dap = require "dap"
local dapui = require "dapui"

-- Firefox adapter configuration
dap.adapters.firefox = {
  type = "executable",
  command = "node",
  args = { vim.fn.stdpath "data" .. "/mason/packages/firefox-debug-adapter/dist/adapter.bundle.js" },
  options = {
    detached = false,
    timeout = 30000,
  },
  -- Add error handling
  on_stderr = function(_, data)
    if data then
      print("Firefox adapter error: " .. vim.inspect(data))
    end
  end,
  on_exit = function(_, code)
    if code ~= 0 then
      print("Firefox adapter exited with code: " .. code)
    end
  end,
}

-- TypeScript/JavaScript configuration
local debug_config = {
  {
    name = "Debug Angular App",
    type = "firefox",
    request = "launch",
    url = "http://localhost:4200",
    webRoot = "${workspaceFolder}",
    timeout = 30000,
    log = {
      errorStream = true,
      stdout = true,
      stderr = true,
    },
    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    sourceMaps = true,
    -- Add these additional configurations for better reliability
    pathMappings = {
      {
        url = "webpack:///",
        path = "${workspaceFolder}/",
      },
    },
    reAttach = true, -- Automatically reattach if connection is lost
    liftAccessorsFromPrototypes = true, -- Improve variable inspection
  },
}

dap.configurations.typescript = debug_config
dap.configurations.javascript = debug_config

-- UI event handlers
local function handle_dap_event(event)
  if event == "connect" then
    print "DAP: Connected to debug adapter"
  elseif event == "disconnect" then
    print "DAP: Disconnected from debug adapter"
  end
end

-- DapUI setup
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
  handle_dap_event "connect"
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
  handle_dap_event "connect"
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
  handle_dap_event "disconnect"
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
  handle_dap_event "disconnect"
end
