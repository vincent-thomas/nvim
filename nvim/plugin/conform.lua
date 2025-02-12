local conform = require('conform')

local JsFormatters = {
  'biome',
  'prettierd',
  'prettier',
  stop_after_first = true,
}

local config = {
  formatters_by_ft = {
    lua = { 'stylua' },
    rust = { 'rustfmt' },
    javascript = JsFormatters,
    javascriptreact = JsFormatters,
    typescript = JsFormatters,
    typescriptreact = JsFormatters,
    nix = { 'nixfmt' },

    cpp = { 'clang-format' },
  },
}

conform.setup(config)

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})
