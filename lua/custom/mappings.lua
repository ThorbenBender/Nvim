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

local create_worktree = function(branch, dir)
  if not branch or not dir then
    vim.notify("Missing branch or directory", vim.log.levels.ERROR)
  end
  require("git-worktree").create_worktree(dir, branch, "origin")
  vim.notify(string.format("Created worktree: dir=%s, branch=%s", dir, branch), vim.log.levels.INFO)
end

local getDir = function(branch)
  vim.ui.input({ prompt = "Directory" }, function(selected)
    if selected and selected ~= "" then
      create_worktree(branch, selected)
    end
  end)
end
local get_remote_branches = function()
  -- Get all remote branches and handle potential errors
  local ok, branches = pcall(vim.fn.systemlist, "git branch -r --format='%(refname:short)'")
  if not ok or not branches or #branches == 0 then
    vim.notify("No remote branches found", vim.log.levels.WARN)
    return {}
  end

  local formatted = {}
  for _, branch in ipairs(branches) do
    -- Only process valid branch names
    if branch and type(branch) == "string" and #branch > 0 then
      -- Skip HEAD reference
      if not branch:match "HEAD" then
        -- Remove origin/ prefix for display
        local display_name = branch:gsub("^origin/", "")
        table.insert(formatted, {
          name = display_name,
          full_name = branch,
        })
      end
    end
  end

  if #formatted == 0 then
    vim.notify("No valid remote branches found", vim.log.levels.WARN)
  end

  return formatted
end

local pick_remote_branch = function(branches)
  for i, branch in ipairs(branches) do
    branches[i] = branch:gsub("%* ", ""):gsub("^%s*", "")
  end
  vim.ui.select(branches, {
    prompt = "Title",
    telescope = require("telescope.themes").get_cursor(),
  }, function(selected)
    if selected then
      getDir(selected)
    end
  end)
end

local getBranch = function()
  vim.ui.input({ prompt = "Enter new branch" }, function(branch)
    if branch then
      getDir(branch)
    end
  end)
end

M.worktrees = {
  n = {
    ["<leader>gw"] = {
      "<cmd>lua require('telescope').extensions.git_worktree.git_worktree()<CR>",
      "Show worktrees",
    },
    ["<leader>ga"] = {
      function()
        getBranch()
      end,
      "Create new worktree",
    },
    ["<leader>gc"] = {
      function()
        local branches = get_remote_branches()
        pick_remote_branch(branches)
      end,
      "Checkout existing branch",
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
    ["<leader>dg"] = {
      function()
        local widgets = require "dap.ui.widgets"
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end,
      "Open debugging sidebar",
    },
    ["<leader>ds"] = {
      "<cmd> DapStepOver <CR>",
      "Next line",
    },
    ["<leader>dr"] = {
      "<cmd> RustDebuggables <CR>",
      "Rust Debugger",
    },
    ["<leader>di"] = {
      "<cmd> DapStepIn <CR>",
      "Step into",
    },
    ["<leader>do"] = {
      "<cmd> DapStepOut <CR>",
      "Step out",
    },
    ["<leader>dc"] = {
      "<cmd> :DapContinue <CR>",
      "Start / Continue",
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
