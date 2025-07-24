return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lsp.config.options
    servers = {
      -- pyright will be automatically installed with mason and loaded with lspconfig
      -- pyrefly = {
      --   cmd = { "pyrefly", "lsp" },
      --   filetypes = { "python" },
      --   root_markers = {
      --     "pyrefly.toml",
      --     "pyproject.toml",
      --     "setup.py",
      --     "setup.cfg",
      --     "requirements.txt",
      --     "Pipfile",
      --     ".git",
      --   },
      -- },
      golangci_lint_ls = {
        cmd = { "golangci-lint-langserver" },
        filetypes = { "go", "gomod" },
        init_options = {
          command = { "golangci-lint", "run", "--output.json.path=stdout", "--show-stats=false" },
        },
        root_markers = {
          ".golangci.yml",
          ".golangci.yaml",
          ".golangci.toml",
          ".golangci.json",
          "go.work",
          "go.mod",
          ".git",
        },
      },
      lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    },
  },
}
