-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
-- vim.opt.formatoptions:remove("r")
-- vim.opt.formatoptions:remove("c")

vim.g.lazyvim_python_lsp = "basedpyright"

-- LazyVim blanks 'clipboard' when $SSH_CONNECTION is set, expecting Neovim to pick
-- OSC 52 on its own -- but that keys off $SSH_TTY, which tmux does not pass through.
vim.opt.clipboard = "unnamedplus"

local osc52 = require("vim.ui.clipboard.osc52")

-- Paste reads the local register rather than querying the terminal; OSC 52 reads are
-- disabled by default in most terminals and would hang every `p`.
local function paste_from_register()
  return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
  paste = { ["+"] = paste_from_register, ["*"] = paste_from_register },
}

-- Set shell to bash for better compatibility with external tools
vim.o.shell = "/bin/zsh"
