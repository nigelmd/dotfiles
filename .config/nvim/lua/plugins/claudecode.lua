local toggle_key = "<M-,>"
return {
  "coder/claudecode.nvim",
  lazy = false,
  dependencies = { "folke/snacks.nvim" },
  config = true,
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
  opts = {
    terminal = {
      ---@module "snacks"
      ---@type snacks.win.Config|{}
      snacks_win_opts = {
        position = "float",
        width = 0.8,
        height = 0.8,
        backdrop = 60,
        border = "rounded", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
        keys = {
          claude_hide = {
            toggle_key,
            function(self)
              self:hide()
            end,
            mode = "t",
            desc = "Hide",
          },
        },
      },
    },
  },

  -- dependencies = {
  --   "nvim-lua/plenary.nvim", -- Required for git operations
  -- },
  -- keys = {
  --   { "<leader>rc", ":ClaudeCode<CR>", desc = "Run Claude Code" },
  -- },
  -- config = function()
  --   require("claude-code").setup({
  --     command = "claude",
  --     window = {
  --       split_ratio = 0.3, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
  --       position = "float", -- Position of the window: "botright", "topleft", "vertical", "float", etc.
  --       enter_insert = true, -- Whether to enter insert mode when opening Claude Code
  --       hide_numbers = true, -- Hide line numbers in the terminal window
  --       hide_signcolumn = true, -- Hide the sign column in the terminal window
  --       -- Floating window configuration (only applies when position = "float")
  --       float = {
  --         width = "80%", -- Width: number of columns or percentage string
  --         height = "80%", -- Height: number of rows or percentage string
  --         row = "center", -- Row position: number, "center", or percentage string
  --         col = "center", -- Column position: number, "center", or percentage string
  --         relative = "editor", -- Relative to: "editor" or "cursor"
  --         border = "rounded", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
  --       },
  --     },
  --     keymaps = {
  --       toggle = {
  --         normal = "<leader>\\", -- Normal mode keymap for toggling Claude Code, false to disable
  --         terminal = "<leader>\\", -- Terminal mode keymap for toggling Claude Code, false to disable
  --       },
  --     },
  --   })
  -- end,
}
