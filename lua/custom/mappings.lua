local M = {}

_G.insert_fold_markers = function()
  -- Ask the user for the region name
  local region_name = vim.fn.input "Region name: "
  -- Escape Lua pattern characters in the region name
  region_name = vim.fn.escape(region_name, "()%.[]*+-?^$")

  local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- Adjust for 0-indexing
  local lines = {
    "// region --- " .. region_name,
    "// endregion --- " .. region_name,
  }
  -- Insert the lines at the current cursor position
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, lines)
  -- Move cursor to the line after the region start to begin typing immediately
  vim.api.nvim_win_set_cursor(0, { current_line + 1, 0 })
end

M.worktrees = {
  n = {
    ["<leader>sr"] = {
      "<cmd>lua require('telescope').extensions.git_worktree.git_worktree()<CR>",
      "Show worktrees",
    },
  },
}

M.general = {
  n = {
    ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
    ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
    ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
    ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
  },
}
M.fold = {
  n = {
    ["<leader>fm"] = {
      "<cmd> lua insert_fold_markers()<CR>",
      "Add fold markers",
    }, -- Removed the extra comma
  },
}

-- M.fold = {
--   n = {
--     ["<leader>fm"] = { "<cmd> lua insert_fold_markers()<CR>", { noremap = true, silent = true }, "Add fold markers" },
--   },
-- }

M.lazygit = {
  n = {
    ["<leader>gt"] = { "<cmd> LazyGit<CR>", "Toggle Git UI" },
  },
}

M.harpoon = {
  n = {
    ["<leader>ha"] = { "<cmd> lua require('harpoon.mark').add_file()<CR>", "Add file to harpoon" },
    ["<leader>hi"] = { "<cmd> lua require('harpoon.ui').toggle_quick_menu()<CR>", "Toggle harpoon interface" },
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

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgt"] = {
      function()
        require("dap-go").debug_test()
      end,
      "Debug go test",
    },
    ["<leader>dgl"] = {
      function()
        require("dap-go").debug_last()
      end,
      "Debug last go test",
    },
  },
}

return M
