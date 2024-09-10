
local cmp = require("cmp")
--
-- require("copilot_cmp").setup()

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  completion = {
    completeopt = "menu,menuone,preview,noselect",
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }, { name = "buffer" }),
})
