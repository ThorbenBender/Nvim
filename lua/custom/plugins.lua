local plugins = {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "williamboman/mason.nvim",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    opts = {
      ensure_installed = require "custom.configs.servers",
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },
  "nvim-lua/plenary.nvim",
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jonarrien/telescope-cmdline.nvim",
    },
    keys = {
      { "Q", "<cmd>Telescope cmdline<cr>", desc = "Cmdline" },
      { "<leader><leader>", "<cmd>Telescope cmdline<cr>", desc = "Cmdline" },
    },
    opts = {
      extensions = {
        cmdline = {},
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension "cmdline"
    end,
  },
  {
    "polarmutex/git-worktree.nvim",
    version = "^2",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    lazy = false,
    config = function()
      local telescope_ok, telescope = pcall(require, "telescope")
      if telescope_ok then
        local ok_extension, extension_message = pcall(telescope.load_extension, "git_worktree")
        if not ok_extension then
          vim.notify("Failed to load git_worktree extension: " .. extension_message, vim.log.levels.ERROR)
        else
          vim.notify("Successfully loaded git_worktree extension", vim.log.levels.INFO)
        end
      else
        vim.notify("Failed to load telescope.nvim: " .. telescope, vim.log.levels.ERROR)
      end
    end,
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
    init = function()
      require("dressing").setup {}
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "custom.configs.conform"
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    opts = {
      ensure_installed = {
        "prettier",
        "clang-format",
        "stylua",
      },
    },
    config = function()
      require("mason-null-ls").setup(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "custom.configs.lspconfig"
      require "plugins.configs.lspconfig"
    end,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = function()
      return require "custom.configs.rust-tools"
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      crates.show()
    end,
  },
  {
    "mfussenegger/nvim-dap",
    init = function()
      require "custom.configs.dap"
      require("core.utils").load_mappings "dap"
    end,
  },
  { "nvim-neotest/nvim-nio" },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup {}
    end,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    init = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local M = require "plugins.configs.cmp"
      table.insert(M.sources, { name = "crates" })
      table.insert(M.sources, { name = "npm", keyword_length = 4 })
      return M
    end,
  },
  {
    "tikhomirov/vim-glsl",
    ft = "glsl",
  },
  {
    "David-Kunz/cmp-npm",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = "json",
    config = function()
      require("cmp-npm").setup {
        ignore = { "beta", "rc" },
        only_semantic_versions = true,
      }
    end,
  },
  {
    "tpope/vim-fugitive",
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension "lazygit"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "svelte",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      local opts = require "plugins.configs.treesitter"
      opts.ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "rust",
      }
      return opts
    end,
  },
  {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup {}
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings "dap_go"
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
}
return plugins
