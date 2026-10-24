-- Follow ~/.config/theme (latte|mocha), written by ~/.local/bin/theme.
local M = {}
local file = vim.fn.expand("~/.config/theme")

function M.flavor()
  local ok, lines = pcall(vim.fn.readfile, file)
  return (ok and lines[1] == "latte") and "latte" or "mocha"
end

function M.apply()
  vim.o.background = M.flavor() == "latte" and "light" or "dark"
  vim.cmd.colorscheme(M.flavor() == "latte" and "onelight" or "onedark_vivid")
end

-- fs_poll (not fs_event): survives the file being rewritten in place or recreated
function M.watch()
  vim.uv.new_fs_poll():start(file, 1000, vim.schedule_wrap(M.apply))
end

return M
