require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

vim.env.PATH = vim.env.PATH .. ":/home/thorben/go/bin"
if custom_init_path then
  dofile(custom_init_path)
end
vim.g.git_worktree_log_level = "debug"
vim.opt.clipboard = "unnamedplus"
local function copy_paste_setup()
  local sysname = vim.loop.os_uname().sysname

  if sysname == "Darwin" then
    -- macOS: Use pbcopy and pbpaste
    vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
    vim.g.clipboard = {
      name = "pbcopy/pbpaste",
      copy = {
        ["+"] = "pbcopy",
        ["*"] = "pbcopy",
      },
      paste = {
        ["+"] = "pbpaste",
        ["*"] = "pbpaste",
      },
      cache_enabled = 0,
    }
    print("macOS detected: using pbcopy/pbpaste for clipboard")
  elseif sysname == "Linux" then
    -- Linux: Use wl-copy and wl-paste
    vim.opt.clipboard = 'unnamedplus'
    vim.g.clipboard = {
      name = "wl-clipboard",
      copy = {
        ["+"] = "wl-copy",
        ["*"] = "wl-copy",
      },
      paste = {
        ["+"] = "wl-paste",
        ["*"] = "wl-paste",
      },
      cache_enabled = 0,
    }
    print("Linux detected: using wl-copy/wl-paste for clipboard")
  else
    print("Unsupported OS detected")
  end
end

-- Call the function to set up clipboard depending on the OS
copy_paste_setup()

vim.opt.relativenumber = true

vim.opt.foldmethod = "marker"
vim.opt.foldmarker = "// region,// endregion"

vim.opt.fillchars = {
  fold = " ",
  horiz = " ",
  horizup = " ",
  horizdown = " ",
  vert = " ",
}
vim.opt.foldtext = "v:lua.My_foldtext()"
function My_foldtext()
  return vim.fn.getline(vim.v.foldstart) .. " "
end

vim.cmd [[highlight Folded guibg=NONE guifg=Grey]]

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"
