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
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
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
    config = function(_, opts)
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
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    cmd = { "DapInstall", "DapUninstall", "DapContinue" },
    config = function()
      require("mason-nvim-dap").setup {
        ensure_installed = { "firefox", "js-debug-adapter", "codelldb", "bash" },
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
          node2 = function()
            config.adapters = {
              type = "executable",
              command = "node-debug2-adapter",
              args = { mason_path .. "package/node-debug2-adapter/out/src/nodeDebug.js" },
            }
            config.configurations.svelte = {
              {
                type = "node2",
                request = "launch",
                program = "${workspaceFolder}/${file}",
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                console = "integratedTerminal",
              },
            }
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup()
    end,
    dependencies = { "mfussenegger/nvim-dap" },
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
}
return plugins
