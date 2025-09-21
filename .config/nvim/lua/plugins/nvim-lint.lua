return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      markdown = { "markdownlint" },
      -- python = { "ruff" },
    },
  },
  config = function()
    local markdownlint = require("lint").linters.markdownlint
    -- local ruffformat = require("lint").linters.ruff
    markdownlint.args = { "--disable", "MD013", "MD007", "--" }
    -- ruffformat.args = { "check" }
  end,
}
