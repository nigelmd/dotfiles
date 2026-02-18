-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Prefer creating groups and assigning autocmds to groups, because it makes it easier to clear them
--[[ Mygroup Group ]]
augroup("mygroup", { clear = true })

local tmux_original_name = nil

autocmd("VimEnter", {
  callback = function()
    if vim.env.TMUX then
      -- Save original window name to restore on exit
      local current = vim.fn.system("tmux display-message -p '#{window_name}'"):gsub("%s+$", "")
      -- Skip if current window is already named editor or editor N
      if current == "editor" or current:match("^editor %d+$") then
        return
      end
      tmux_original_name = current
      -- Find existing editor windows
      local windows = vim.fn.system("tmux list-windows -F '#{window_name}'")
      local editor_exists = false
      local max_num = 0
      for line in windows:gmatch("[^\n]+") do
        if line == "editor" then
          editor_exists = true
        end
        local num = line:match("^editor (%d+)$")
        if num then
          max_num = math.max(max_num, tonumber(num))
        end
      end
      if not editor_exists then
        vim.fn.system("tmux rename-window editor")
      else
        vim.fn.system("tmux rename-window 'editor " .. math.max(max_num + 1, 1) .. "'")
      end
    end
  end,
  group = "mygroup",
  desc = "Rename tmux window to editor on VimEnter",
})

autocmd("VimLeave", {
  callback = function()
    if vim.env.TMUX and tmux_original_name then
      vim.fn.system("tmux rename-window " .. vim.fn.shellescape(tmux_original_name))
    end
  end,
  group = "mygroup",
  desc = "Restore original tmux window name on VimLeave",
})

autocmd("Filetype", {
  pattern = { "*" },
  callback = function()
    -- vim.opt.formatoptions = vim.opt.formatoptions - "o"
    vim.opt.formatoptions = vim.opt.formatoptions
      + {
        o = false, -- Don't continue comments with o and O
        r = false, -- Don't add comments in insert mode
      }
  end,
  group = "mygroup",
  desc = "Don't continue comments with o and O",
})
