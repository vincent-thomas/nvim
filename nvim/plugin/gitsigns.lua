local gitsigns = require('gitsigns')

gitsigns.setup()

vim.keymap.set('n', 'gh', gitsigns.preview_hunk_inline)
vim.keymap.set('n', 'gb', gitsigns.blame_line)
vim.keymap.set('n', 'gB', gitsigns.blame)
