return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux",
  },
  vim.keymap.set("n", "<leader>tc", ":TestNearest<CR>", { desc = "[T]est [C]urrent method" }),
  vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "[T]est the entire [F]ile" }),
  vim.keymap.set("n", "<leader>ta", ":TestSuite<CR>", { desc = "[T]est [A]ll in project" }),
  vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "[T]est [L]ast file/method" }),
  vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { desc = "[T]est [V]isit" }),
  vim.cmd("let test#strategy = 'vimux'"),
}
