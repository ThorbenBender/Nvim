local M

M.worktree = {
  n = {
    ["<leader>w"] = { "<cmd> lua require('telescope').extensions.git_worktree.git_worktree() <CR>", "Show worktrees" },
  },
}
return M
