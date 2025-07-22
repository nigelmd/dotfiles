return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  "olimorris/onedarkpro.nvim", -- One Dark pro theme
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    -- Original setup took a dictionary however this theme onedarkpro wants it different
    require("onedarkpro").setup({
      styles = {
        types = "bold",
        methods = "bold",
        numbers = "bold",
        strings = "bold",
        comments = "bold",
        keywords = "bold,italic",
        constants = "bold",
        functions = "bold",
        operators = "bold",
        variables = "bold",
        parameters = "bold",
        conditionals = "italic",
        virtual_text = "bold",
      },
      highlights = {
        Comment = { bold = true },
        Directory = { bold = true },
        ErrorMsg = { italic = true, bold = true },
        MiniStatuslineModeInsert = { bg = "${green}", fg = "black" },
        ["@function.call"] = { fg = "${red}" },
        ["@function.method.call"] = { fg = "${orange}" },
        ["@variable.member"] = { fg = "${blue}" },
        ["@constructor"] = { fg = "${green}" },
        ["@module"] = { fg = "${orange}" },
        ["@odp.import_module.python"] = { fg = "${cyan}" },
      },
    })

    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme("onedark_vivid")
  end,
}
