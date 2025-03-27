require('mini.misc').setup {
  make_global = { 'put_text' },
}

require('mini.statusline').setup()
require('mini.icons').setup()
require('mini.hipatterns').setup()
require('mini.base16').setup {
  palette = require('vt.theme').catpuccinMocha,
}

local pick = require('mini.pick')
local extras = require('mini.extra')

extras.setup()
pick.setup {
  options = {
    content_from_bottom = true,
    use_cache = true,
  },
}

vim.ui.select = pick.ui_select

vim.keymap.set('n', '<C-p>', pick.builtin.files)
vim.keymap.set('n', '<C-g>', pick.builtin.grep_live)

vim.keymap.set('n', 'gt', function()
  extras.pickers.lsp { scope = 'type_definition' }
end)

vim.keymap.set('n', 'gi', function()
  extras.pickers.lsp { scope = 'implementation' }
end)

vim.keymap.set('n', 'gr', function()
  extras.pickers.lsp { scope = 'references' }
end)
vim.keymap.set('n', '<C-e>', function()
  extras.pickers.diagnostic { scope = 'all', sort_by = 'severity' }
end)
