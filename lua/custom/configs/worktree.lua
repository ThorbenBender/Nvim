package.loaded["git-worktree.hooks"] = nil
local Hooks = require "git-worktree.hooks"
local update_on_switch = Hooks.builtins.update_current_buffer_on_switch

Hooks.register(Hooks.type.SWITCH, function(prev_path, path)
  vim.notify("Switched path from " .. prev_path .. " to " .. path)
  update_on_switch(path, prev_path)
end)
Hooks.register(Hooks.type.CREATE, function(path, branch, upstream)
  vim.notify("Loaded " .. path .. " and " .. branch .. " and " .. upstream)
end)
