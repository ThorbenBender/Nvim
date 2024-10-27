local options = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    selection_caret = "  ",
    prompt_prefix = "   ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = "truncate",
    winblend = 0,
    border = true,
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    preview = {
      hide_on_startup = true,
    },
    mappings = {
      n = {
        ["q"] = require("telescope.actions").close,
        ["p"] = require("telescope.actions.layout").toggle_preview,
      },
      i = {
        ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
      },
    },
  },
  pickers = {
    highlights = {
      theme = "dropdown",
      previewer = false,
    },
  },
  extensions_list = { "themes", "terms" },
}

-- Set up highlight groups separately
vim.api.nvim_command "highlight TelescopePromptPrefix guifg=#89dceb"
vim.api.nvim_command "highlight TelescopeSelection guibg=#313244 gui=bold"
vim.api.nvim_command "highlight TelescopeMatching guifg=#89b4fa"
vim.api.nvim_command "highlight TelescopeBorder guifg=#585b70"

return options
