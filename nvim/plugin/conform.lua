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

    html = { 'prettierd', 'prettier', stop_after_first = true },

    _ = { 'trim_whitespace' },
  },
}

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})
