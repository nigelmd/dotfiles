-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
-- vim.opt.formatoptions:remove("r")
-- vim.opt.formatoptions:remove("c")

vim.g.lazyvim_python_lsp = "basedpyright"

-- Set shell to bash for better compatibility with external tools
vim.o.shell = "/bin/bash"
