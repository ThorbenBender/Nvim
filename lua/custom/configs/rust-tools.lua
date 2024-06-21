local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local rt = require "rust-tools"

local options = {
  on_attach = on_attach,
  capabilities = capabilities,
  server = {

    settings = {
      ["rust-analyzer"] = {
        cmd = { "/usr/bin/rust-analyzer" },
        check = {
          command = "clippy",
        },
      },
    },
  },
}

return options
