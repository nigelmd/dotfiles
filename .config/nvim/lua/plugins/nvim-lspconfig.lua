return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    -- ---@type lsp.config.options
    servers = {
      ruff = {
        mason = false,
        autostart = true,
        -- settings = {
        --   python = {
        --     pythonPath = vim.fn.getcwd() .. "/.venv/bin/python",
        --   },
        -- },
      },
      ruff_lsp = {
        mason = false,
        autostart = true,
        -- settings = {
        --   python = {
        --     pythonPath = vim.fn.getcwd() .. "/.venv/bin/python",
        --   },
        -- },
      },
      pyright = {
        mason = false,
        autostart = false,
        settings = {
          pyright = {
            disableOrganizeImports = true, -- Using Ruff
          },
          python = {
            analysis = {
              ignore = { "*" }, -- Using Ruff
              typeCheckingMode = "off", -- Using mypy
            },
          },
        },
      },
      basedpyright = {
        mason = false,
        autostart = true,
        autoImportCompletions = true,
        autoSearchPaths = true,
        inlayHints = {
          functionReturnTypes = false,
          variableTypes = false,
          parameterTypes = false,
        },
        diagnosticMode = "workspace",
        typeCheckingMode = "basic", -- standard, strict, all, off, basic
        settings = {
          pyright = {
            disableOrganizeImports = true, -- Using Ruff
          },
          python = {
            analysis = {
              ignore = { "*" }, -- Using Ruff
              typeCheckingMode = "off", -- Using mypy
            },
          },
        },
        -- settings = {
        --   python = {
        --     pythonPath = vim.fn.getcwd() .. "/.venv/bin/python",
        --   },
        -- },
      },
      gopls = {
        -- Example custom settings:
        -- Enable semantic tokens for richer highlighting
        semanticTokens = true,
        -- Configure staticcheck
        staticcheck = true,
        -- Exclude specific directories from analysis
        directoryFilters = { "-.git", "-node_modules" },
        -- Other gopls options as needed
      },
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
