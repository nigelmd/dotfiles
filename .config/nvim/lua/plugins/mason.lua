return {
  "mason-org/mason.nvim",
  -- version = "*",
  opts = {
    ensure_installed = {
      "stylua",
      "shellcheck",
      "shfmt",
      -- "pyrefly",
      -- "ruff",
      -- "black",
      "gopls",
      "goimports",
      "gofumpt",
      "gomodifytags",
      "impl",
    },
  },
}
