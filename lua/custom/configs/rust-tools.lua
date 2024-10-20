local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local options = {
  on_attach = on_attach,
  capabilities = capabilities,
  server = {

    settings = {
      ["rust-analyzer"] = {
        cmd = { "/usr/bin/rust-analyzer" },
        check = {
          command = "clippy",
          extraArgs = { "--all-targets", "--all-features" },
        },
        displayInlayHints = true,
        cargo = {
          features = "all",
        },
      },
    },
  },
  tools = {
    inlay_hints = {
      only_current_line = true,
    },
  },
}

return options
