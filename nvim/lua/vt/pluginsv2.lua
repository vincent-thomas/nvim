-- TREESITTER
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then
      vim.notify(
        'File larger than 100KB treesitter disabled for performance',
        vim.log.levels.WARN,
        { title = 'Treesitter' }
      )
      return
    end
    pcall(vim.treesitter.start, args.buf)
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

-- BLINK CMP

require('blink.cmp').setup {
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
    ['<C-c>'] = 'actions.close',
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

-- NVIM

require('mini.misc').setup {
  make_global = { 'put_text' },
}

require('mini.statusline').setup()
require('mini.icons').setup()
require('mini.hipatterns').setup()

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

vim.keymap.set('n', '<C-s>', function()
  extras.pickers.lsp { scope = 'document_symbol' }
end)

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
    -- gitsigns = true,
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
