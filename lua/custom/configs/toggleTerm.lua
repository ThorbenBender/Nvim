local toggleTerm = require "toggleTerm"
local Terminal = require("toggleTerm.terminal").Terminal

toggleTerm.setup {
  size = 20,
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "Normal",
    background = "Normal",
  },
}

vim.keymap.set("n", "<leader>gi", '<CMD> lua print("Hello") <CR>', "Toggle Git UI")
local lazygit = Terminal:new {
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd "startinsert!"
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
  -- function to run on closing the terminal
  on_close = function(term)
    vim.cmd "startinsert!"
  end,
}

function _toggleTerm()
  lazygit:toggle()
end

local toggleTerm = {
  plugin = true,
  n = {
    ["<leader>gi"] = {
      function()
        toggleTerm()
      end,
      "Toggle Lazygit",
    },
  },
}

local M = require "custom.mappings"
table.insert(M, toggleTerm)
print(M)
