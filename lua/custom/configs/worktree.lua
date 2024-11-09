-- Debug print to confirm this file is being loaded
print "Loading git-worktree hooks configuration..."

package.loaded["git-worktree.hooks"] = nil
local Hooks = require "git-worktree.hooks"
local update_on_switch = Hooks.builtins.update_current_buffer_on_switch

print("Hooks loaded:", vim.inspect(Hooks))

local old_emit = Hooks.emit
function Hooks.emit(type, ...)
  print("Emitting hook:", type, vim.inspect { ... })
  for _, hook in pairs(hooks[type]) do
    old_emit(...)
  end
end

Hooks.register(Hooks.type.SWITCH, function(prev_path, path)
  vim.notify("Switched path from " .. prev_path .. " to " .. path)
  update_on_switch(path, prev_path)
end)
Hooks.register(Hooks.type.CREATE, function(path, branch, upstream)
  vim.notify("Loaded " .. path .. " and " .. branch .. " and " .. upstream)
end)
