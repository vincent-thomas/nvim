local lspconfig = require('lspconfig')
local nvim_cmp_nvim_lsp = require('cmp_nvim_lsp')

local function keybinds(ev)
  local opts = { buffer = ev.buf, silent = true }
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<C-a>', vim.lsp.buf.code_action, opts)
end

local capabilities = nvim_cmp_nvim_lsp.default_capabilities()

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

lspconfig.biome.setup {
  capabilities,
}

lspconfig.emmet_ls.setup {
  capabilities,
  filetypes = { 'css', 'html', 'javascriptreact', 'typescriptreact' },
}

lspconfig.gopls.setup {
  capabilities,
}

lspconfig.lua_ls.setup {
  capabilities,
}
lspconfig.rust_analyzer.setup {
  capabilities,
}

lspconfig.terraformls.setup { capabilities }
lspconfig.tflint.setup { capabilities }

lspconfig.marksman.setup { capabilities }

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = keybinds,
})
