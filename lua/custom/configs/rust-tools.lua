local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local rt = require("rust-tools")

local options = {
  server = {
    on_attach = function (client, bufnr)
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, {buf: bufnr})
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, {buf: bufnr})
    end,
    capabilities = capabilities
  }
}

return options
