local M = {}

M.create_worktree = function(branch, dir)
  if not branch or not dir then
    vim.notify("Missing branch or directory", vim.log.levels.ERROR)
  end
  require("git-worktree").create_worktree(dir, branch, "origin")
  vim.notify(string.format("Created worktree: dir=%s, branch=%s", dir, branch), vim.log.levels.INFO)
end

local getDir = function(branch)
  vim.ui.input({ prompt = "Directory" }, function(selected)
    if selected and selected ~= "" then
      M.create_worktree(branch, selected)
    end
  end)
end
M.get_remote_branches = function()
  -- Get all remote branches and handle potential errors
  local ok, branches = pcall(vim.fn.systemlist, "git branch  --format='%(refname:short)'")
  if not ok or not branches or #branches == 0 then
    vim.notify("No remote branches found", vim.log.levels.WARN)
    return {}
  end

  local formatted = {}
  for _, branch in ipairs(branches) do
    -- Only process valid branch names
    vim.notify("Unformatted: " .. branch)
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

M.pick_remote_branch = function(branches)
  for i, branch in ipairs(branches) do
    vim.notify("Branches " .. branch.full_name)
    branches[i] = branch.full_name:gsub("%* ", ""):gsub("^%s*", "")
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

M.create_new_worktree = function()
  local branches = M.get_remote_branches()
  M.pick_remote_branch(branches)
end
M.getBranch = function()
  vim.ui.input({ prompt = "Enter new branch" }, function(branch)
    if branch then
      getDir(branch)
    end
  end)
end

M.get_all_worktree = function()
  local worktrees = vim.fn.systemlist "git worktree list"
  local filtered_worktree = {}
  for _, worktree in ipairs(worktrees) do
    if not worktree:match "bare" then
      local formatted_worktree = worktree:match ".*/(.-)%s+"
      table.insert(filtered_worktree, formatted_worktree)
    end
  end
  return filtered_worktree
end

M.delete_worktree_call = function()
  local worktrees = M.get_all_worktree()
  vim.ui.select(
    worktrees,
    { title = "Delete Worktree", telescope = require("telescope.themes").get_cursor() },
    function(worktree)
      vim.notify("Worktree: " .. worktree)
      require("git-worktree").delete_worktree(worktree)
    end
  )
end

return M
