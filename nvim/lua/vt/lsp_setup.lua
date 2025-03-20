local M = {}

-- Hack to order functions in other way
local _priv = {}

function M.setup_lsp(capabilities)
  local lspconfig = require('lspconfig')

  for lsp, config in pairs(_priv.lsps(capabilities)) do
    lspconfig[lsp].setup(config)
  end

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local opts = { buffer = ev.buf, silent = true }
      vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', '<C-a>', vim.lsp.buf.code_action, opts)
    end,
  })
end

function _priv.lsps(capabilities)
  return {
    astro = { capabilities },
    ts_ls = { capabilities },
    dockerls = { capabilities },
    pyright = { capabilities },
    nixd = { capabilities },
    statix = { capabilities },
    emmet_ls = {
      capabilities,
      filetypes = { 'css', 'html', 'javascriptreact', 'typescriptreact', 'eruby' },
    },
    gopls = { capabilities },
    lua_ls = { capabilities },
    rust_analyzer = {
      capabilities,
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
          },
        },
      },
    },
    terraformls = { capabilities },
    tflint = { capabilities },
    marksman = { capabilities },
    clangd = { capabilities },
  }
end

return M
