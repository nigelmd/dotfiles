-- Follow ~/.config/theme (latte|mocha), written by ~/.local/bin/theme.
local M = {}
local file = vim.fn.expand("~/.config/theme")

local function load()
  local ok, lines = pcall(vim.fn.readfile, file)
  M.current = (ok and lines[1] == "latte") and "latte" or "mocha"
  M.palette = require("catppuccin.palettes").get_palette(M.current) -- lualine reads this every refresh
end
load()

function M.apply()
  load()
  vim.o.background = M.current == "latte" and "light" or "dark"
  vim.cmd.colorscheme(M.current == "latte" and "onelight" or "onedark_vivid")
end

-- fs_poll (not fs_event): survives the file being rewritten in place or recreated
function M.watch()
  vim.uv.new_fs_poll():start(file, 1000, vim.schedule_wrap(M.apply))
end

return M
