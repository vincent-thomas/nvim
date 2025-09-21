--- Treesitter
local config = {
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    enable_autocmd = false,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        vim.notify(
          'File larger than 100KB treesitter disabled for performance',
          vim.log.levels.WARN,
          { title = 'Treesitter' }
        )
        return true
      end
    end,
  },
  indent = { enable = true },
}

require('nvim-treesitter.configs').setup(config)

--- OIL

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

--- GITSIGNS
local gitsigns = require('gitsigns')

gitsigns.setup()

vim.keymap.set('n', 'gb', gitsigns.blame_line)
vim.keymap.set('n', 'gB', gitsigns.blame)

--- CONFORM
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

    cpp = { 'clang-format' },

    sql = { 'sqlfluff' },

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

--- Catpuccin
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
    cmp = true,
    gitsigns = true,
    treesitter = true,
    mini = {
      enabled = true,
      indentscope_color = '',
    },
  },
}

-- setup must be called before loading
vim.cmd.colorscheme('catppuccin')

--- FIDGET
require('fidget').setup {}

-- MINI
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

vim.keymap.set('n', 'gs', function()
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

--- BLINK
local blink = require('blink.cmp')

blink.setup {
  sources = {
    default = { 'lsp', 'path', 'buffer' },
  },
  keymap = { preset = 'default' },
  fuzzy = {
    implementation = 'lua',
  },
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = 'mono',
  },
  completion = {
    trigger = { prefetch_on_insert = false },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
  signature = { enabled = true },
}

require('leap').set_default_mappings()

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<C-a>', vim.lsp.buf.code_action, opts)
  end,
})

vim.lsp.enable('ts_ls')
vim.lsp.enable('dockerls')
vim.lsp.enable('nixd')
vim.lsp.enable('statix')
vim.lsp.enable('emmet_ls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analyzer')
