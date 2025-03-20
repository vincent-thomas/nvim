local blink = require('blink.cmp')

local capabilities = vim.lsp.protocol.make_client_capabilities()

require('vt.lsp_setup').setup_lsp(capabilities)

blink.setup {
  keymap = { preset = 'default' },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },
  signature = { enabled = true },
}
