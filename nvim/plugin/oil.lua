require('oil').setup {
  default_file_explorer = true,
  columns = {
    'icon',
  },
  use_default_keymaps = false,
  keymaps = {
    ['g?'] = 'actions.show_help',
    ['<CR>'] = 'actions.select',
    ['<C-c>'] = 'actions.close',
    ['<C-l>'] = 'actions.refresh',
    ['-'] = 'actions.parent',
    ['_'] = 'actions.open_cwd',
    ['gs'] = 'actions.change_sort',
    ['t'] = 'actions.open_external',
    ['.'] = 'actions.toggle_hidden',
    ['g\\'] = 'actions.toggle_trash',
  },
  preview_split = 'left',
  filters = {
    dotfiles = false,
  },
}
vim.keymap.set('n', '-', '<cmd>Oil<cr>')
