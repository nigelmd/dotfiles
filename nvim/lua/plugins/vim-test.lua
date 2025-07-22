return {
  'vim-test/vim-test',
  dependencies = {
    'preservim/vimux',
  },
  vim.keymap.set('n', '<leader>t', ':TestNearest<CR>', { desc = '[T]est nearest method' }),
  vim.keymap.set('n', '<leader>T', ':TestFile<CR>', { desc = '[T]est the entire file' }),
  vim.keymap.set('n', '<leader>a', ':TestSuite<CR>', { desc = 'Test [A]ll in project' }),
  vim.keymap.set('n', '<leader>l', ':TestLast<CR>', { desc = 'Test [L]ast file/method' }),
  vim.keymap.set('n', '<leader>g', ':TestVisit<CR>'),
  vim.cmd "let test#strategy = 'vimux'",
}
