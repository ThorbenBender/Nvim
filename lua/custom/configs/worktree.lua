-- Debug print to confirm this file is being loaded
print "Loading git-worktree hooks configuration..."

package.loaded["git-worktree.hooks"] = nil
local Hooks = require "git-worktree.hooks"

print("Hooks loaded:", vim.inspect(Hooks))

local old_emit = Hooks.emit
Hooks.emit = function(type, ...)
  print("Hook emitted:", type, vim.inspect { ... })
  return old_emit(type, ...)
end
Hooks.register(Hooks.type.CREATE, function(path, branch, upstream)
  vim.notify("Loaded " .. path .. " and " .. branch .. " and " .. upstream)
end)
