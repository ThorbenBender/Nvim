local M = {}

M.general = {
  n = {
    ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
    ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
    ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
    ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
  },
}

M.lazygit = {
  n = {
    ["<leader>gt"] = { "<cmd> LazyGit<CR>", "Toggle Git UI" },
  },
}

M.glsl = {
  n = {
    ["<leader>gl"] = {
      function()
        require("glslView").glslView { "-w", "128", "-h", "256" }
      end,
    },
  },
}

M.dap = {
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Toggle breakpoint",
    },
    ["<leader>dt"] = {
      function()
        require("dapui").toggle()
      end,
      "Toggle Dapui Interface",
    },
    ["<leader>dus"] = {
      function()
        local widgets = require "dap.ui.widgets"
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end,
      "Open debugging sidebar",
    },
    ["<leader>dp"] = {
      "<cmd> DapStepOver <CR>",
      "Go to next line in debugger",
    },
    ["<leader>dr"] = {
      "<cmd> RustDebuggables <CR>",
      "Rust Debugger",
    },
  },
}

return M
