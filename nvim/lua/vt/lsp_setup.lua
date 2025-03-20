local function keybinds(ev)
  local opts = { buffer = ev.buf, silent = true }
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<C-a>', vim.lsp.buf.code_action, opts)
end

local M = {}

function M.setup_lsp(capabilities)
  local lspconfig = require('lspconfig')

  lspconfig.astro.setup {
    capabilities,
  }

  lspconfig.ts_ls.setup {
    capabilities,
  }

  lspconfig.dockerls.setup {
    capabilities,
  }

  lspconfig.pyright.setup {
    capabilities,
  }

  lspconfig.nixd.setup {
    capabilities,
  }

  lspconfig.statix.setup {
    capabilities,
  }

  lspconfig.emmet_ls.setup {
    capabilities,
    filetypes = { 'css', 'html', 'javascriptreact', 'typescriptreact', 'eruby' },
  }

  lspconfig.gopls.setup {
    capabilities,
  }

  lspconfig.lua_ls.setup {
    capabilities,
  }
  lspconfig.rust_analyzer.setup {
    capabilities,
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
        },
      },
    },
  }

  lspconfig.terraformls.setup { capabilities }
  lspconfig.tflint.setup { capabilities }

  lspconfig.marksman.setup { capabilities }

  lspconfig.clangd.setup { capabilities }

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = keybinds,
  })
end

return M
