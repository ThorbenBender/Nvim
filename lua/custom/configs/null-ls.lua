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
    formatting.prettier.with {
      extra_filetypes = { "svelte", "vue" },
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
  },
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
        [[ desc = "[lsp] format on save" ]],
      })
    end
  end,
}
return opts
