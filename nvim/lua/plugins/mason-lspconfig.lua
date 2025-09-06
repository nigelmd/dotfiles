return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    automatic_installation = {
      exclude = {
        "ruff",
        "ruff_lsp",
        "pyright",
        "basedpyright",
      },
    },
    ensure_installed = {
      -- List only the servers you want installed
      -- Don't include ruff here
    },
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
