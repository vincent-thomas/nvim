---- OPTS:
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.guicursor = ''

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 4
vim.opt.termguicolors = true
vim.g.mapleader = ' '
vim.opt.colorcolumn = '80'
vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.rnu = false
-- Border nice
vim.o.winborder = 'rounded'
-- System clipboard
vim.opt.clipboard = 'unnamedplus'

--
-- Removes default '-- INSERT --', i have my bar
vim.opt.showmode = false

vim.cmd('set nocompatible')

vim.opt.shortmess = vim.opt.shortmess
  + {
    c = true, -- Do not show completion messages in command line
    F = true, -- Do not show file info when editing a file, in the command line
    W = true, -- Do not show "written" in command line when writing
    I = true, -- Do not show intro message when starting Vim
  }

---- Remap ----

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Eagle filetype detection and tree-sitter parser mapping
vim.filetype.add {
  extension = {
    eagle = 'eagle',
    eeagle = 'eagle',
  },
}
vim.treesitter.language.register('tcl', 'eagle')

-- PLUGINS:

vim.pack.add {
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/nvim-mini/mini.icons',
  'https://github.com/stevearc/oil.nvim',
  'https://codeberg.org/andyg/leap.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/saghen/blink.lib',
  'https://github.com/saghen/blink.cmp',
}

-- TREESITTER
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then
      pcall(vim.treesitter.stop, args.buf)
      vim.notify(
        'File larger than 100KB treesitter disabled for performance',
        vim.log.levels.WARN,
        { title = 'Treesitter' }
      )
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<C-a>', vim.lsp.buf.code_action, opts)
    vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })
  end,
})

vim.lsp.enable('ts_ls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('nixd')
vim.lsp.enable('bashls')
vim.lsp.enable('marksman')
vim.lsp.enable('gopls')
vim.lsp.enable('eagle')

-- BLINK CMP

local blink_cmp = require('blink.cmp')
if not blink_cmp.library_available() then
  blink_cmp.build():pwait()
end
blink_cmp.setup {
  keymap = {
    preset = 'default',
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-Space>'] = { 'show', 'fallback' },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<C-y>'] = { 'accept', 'fallback' },
    ['<C-CR>'] = { 'cancel', 'fallback' },
  },
  sources = {
    default = { 'lsp', 'path', 'buffer' },
  },
  completion = {
    list = {
      selection = { preselect = true, auto_insert = false },
    },
  },
}

-- OIL

local oil = require('oil')
--
oil.setup {
  default_file_explorer = true,
  columns = {
    'icon',
  },
  use_default_keymaps = false,
  keymaps = {
    ['<CR>'] = 'actions.select',
    ['<Esc>'] = 'actions.close',
    ['<C-l>'] = 'actions.refresh',
    ['-'] = 'actions.parent',
    ['_'] = 'actions.open_cwd',
    ['.'] = 'actions.toggle_hidden',
  },
  preview_split = 'left',
  filters = {
    dotfiles = false,
  },
}

vim.keymap.set('n', '-', vim.cmd.Oil)

-- LEAP

vim.keymap.set({ 'n', 'o', 'x' }, 's', '<Plug>(leap)')

-- FZF-lua
local fzf_lua = require('fzf-lua')
fzf_lua.setup {
  files = {
    cmd = 'fd --type f --hidden --exclude .git',
  },
}
vim.keymap.set('n', '<C-p>', fzf_lua.files)
vim.keymap.set('n', '<C-g>', fzf_lua.live_grep)
vim.keymap.set('n', 'gi', fzf_lua.lsp_implementations)
vim.keymap.set('n', 'gr', fzf_lua.lsp_references)
vim.keymap.set('n', 'gt', fzf_lua.lsp_typedefs)
vim.keymap.set('n', 'gs', fzf_lua.lsp_document_symbols)
vim.keymap.set('n', '<C-e>', fzf_lua.lsp_workspace_diagnostics)

-- List all TODO/FIXME comments in the project
vim.keymap.set('n', 'gf', function()
  fzf_lua.grep {
    search = '(TODO|FIXME|HACK|NOTE|XXX|BUG):?',
    no_esc = true,
  }
end, { desc = 'List TODO/FIXME comments' })

-- NVIM
require('mini.icons').setup()

-- CATPPUCCIN
require('catppuccin').setup {
  flavour = 'mocha', -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = 'latte',
    dark = 'mocha',
  },
  transparent_background = false, -- disables setting the background color.
  show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false, -- dims the background color of inactive window
    shade = 'dark',
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { 'italic' }, -- Change the style of comments
    conditionals = { 'italic' },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    -- miscs = {}, -- Uncomment to turn off hard-coded styles
  },
  color_overrides = {},
  custom_highlights = {},
  default_integrations = true,
  integrations = {
    blink_cmp = true,
    treesitter = true,
    mini = {
      enabled = true,
      indentscope_color = '',
    },
  },
}

-- setup must be called before loading
vim.cmd.colorscheme('catppuccin')

-- CONFORM
local conform = require('conform')

local JsFormatters = {
  'prettierd',
  'prettier',
  stop_after_first = true,
}

conform.setup {
  formatters_by_ft = {
    lua = { 'stylua' },

    rust = { 'rustfmt' },

    javascript = JsFormatters,
    javascriptreact = JsFormatters,
    typescript = JsFormatters,
    typescriptreact = JsFormatters,

    nix = { 'nixfmt' },

    html = JsFormatters,

    _ = { 'trim_whitespace' },
  },
}

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})
