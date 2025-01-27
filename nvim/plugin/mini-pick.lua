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

local function pick_impl()
  extras.pickers.lsp { scope = 'implementation' }
end

local function pick_type_def()
  extras.pickers.lsp { scope = 'type_definition' }
end

local function pick_diagnostic()
  extras.pickers.diagnostic { scope = 'all', sort_by = 'severity' }
end

vim.keymap.set('n', '<C-p>', pick.builtin.files)
vim.keymap.set('n', '<C-g>', pick.builtin.grep_live)
vim.keymap.set('n', 'gt', pick_type_def)
vim.keymap.set('n', 'gi', pick_impl)
vim.keymap.set('n', '<C-e>', pick_diagnostic)
