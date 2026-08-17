-- Walk up from `start_dir` looking for the nearest virtualenv directory
-- (one containing `bin/python`). Returns its absolute path or nil.
-- This is what makes worktrees under <repo>/.claude/worktrees/<name> work:
-- a worktree with its own .venv gets it; one without walks up to the parent repo's .venv.
local function find_venv(start_dir)
  local uv = vim.uv or vim.loop
  local names = { ".venv", "venv", "env" }
  local dir = vim.fn.fnamemodify(start_dir, ":p"):gsub("/$", "")
  while dir and dir ~= "" do
    for _, name in ipairs(names) do
      local venv = dir .. "/" .. name
      if uv.fs_stat(venv .. "/bin/python") then
        return venv
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
  return nil
end

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
        -- Launch basedpyright-langserver from the nearest venv (walking up from the
        -- resolved project root). Falls back to PATH if the venv lacks it / none found.
        cmd = function(dispatchers, config)
          local root = config.root_dir or vim.fn.getcwd()
          local venv = find_venv(root)
          local exe = "basedpyright-langserver"
          if venv then
            local cand = venv .. "/bin/basedpyright-langserver"
            if (vim.uv or vim.loop).fs_stat(cand) then
              exe = cand
            end
          end
          return vim.lsp.rpc.start({ exe, "--stdio" }, dispatchers, { cwd = root })
        end,
        -- Point analysis at that same venv's interpreter so third-party imports resolve.
        before_init = function(_, config)
          local venv = find_venv(config.root_dir or vim.fn.getcwd())
          if venv then
            config.settings = config.settings or {}
            config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, {
              pythonPath = venv .. "/bin/python",
            })
          end
        end,
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
