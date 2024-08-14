local null_ls = require "null-ls"
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local formatting = null_ls.builtins.formatting
local opts = {
  sources = {
    formatting.gofumpt,
    formatting.goimports_reviser,
    formatting.golines,
    formatting.stylua,
    formatting.clang_format,
  },
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      local ok, err = pcall(function()
        vim.api.nvim_clear_autocmds {
          group = augroup,
          buffer = bufnr,
        }
      end)
      if not ok then
        print("Error at clearing buffer", err)
      end
      ok, err = pcall(function()
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            print("formatting")
            vim.lsp.buf.format { bufnr = bufnr }
          end,
          desc = "[lsp] format on save",
        })
      end)
      if not ok then
        print("Error creating autocommand:", err)
      end
    end
  end,
}
return opts
