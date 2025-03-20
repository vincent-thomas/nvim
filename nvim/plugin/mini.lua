local pick = require('mini.pick')
local extras = require('mini.extra')

local visits = require('mini.visits')

local icons = require('mini.icons')

icons.setup()
visits.setup()
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

local function pick_references()
  extras.pickers.lsp { scope = 'references' }
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
vim.keymap.set('n', 'gr', pick_references)
vim.keymap.set('n', '<C-e>', pick_diagnostic)

vim.keymap.set('n', '<C-t>', extras.pickers.visit_paths)
vim.keymap.set('n', 'td', visits.remove_path)

local base16 = require('mini.base16')

base16.setup {
  use_cterm = true,
  palette = {
    base00 = '#24273a',
    base01 = '#1e2030',
    base02 = '#363a4f',
    base03 = '#494d64',
    base04 = '#5b6078',
    base05 = '#cad3f5',
    base06 = '#f4dbd6',
    base07 = '#b7bdf8',
    base08 = '#ed8796',
    base09 = '#f5a97f',
    base0A = '#eed49f',
    base0B = '#a6da95',
    base0C = '#8bd5ca',
    base0D = '#8aadf4',
    base0E = '#c6a0f6',
    base0F = '#f0c6c6',
  },
}
