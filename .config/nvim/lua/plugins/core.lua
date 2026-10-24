return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local theme = require("config.theme")
        theme.apply()
        theme.watch()
      end,
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "classic",
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      dim = {
        enabled = true,
      },
      statuscolumn = {
        enabled = true,
      },
    },
  },
}
