


local status, conform = pcall(require, "conform")
if not status then 
  print("conform did not load")
  return
end

conform.setup({
  formatters_by_ft = {
		-- lua
		lua = { "stylua" },
		-- base web formats (use a sub-list to run only the first available formatter)
		javascript = { "prettier" },
		typescript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		-- svelte
		svelte = {  "prettier" },
		-- react
		javascriptreact = {  "prettier" },
		typescriptreact = {  "prettier" },
		-- json
		json = { "prettier" },
		-- everything else will use lsp format
	},
	-- enable format on save
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 4000,
		lsp_fallback = true,
	},
})
