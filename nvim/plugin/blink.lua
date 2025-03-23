local blink = require('blink.cmp')

local capabilities = vim.lsp.protocol.make_client_capabilities()

require('vt.lsp_setup').setup_lsp(capabilities)

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
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
  signature = { enabled = true },
}
