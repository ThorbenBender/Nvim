require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

vim.env.PATH = vim.env.PATH .. ":/home/thorben/go/bin"
if custom_init_path then
  dofile(custom_init_path)
end
vim.opt.clipboard = "unnamedplus"
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
  cache_enabled = 1,
}

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
