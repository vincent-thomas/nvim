return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
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
    end,
  },
  -- the colorscheme should be available when starting Neovim
  {
    'neovim/nvim-lspconfig',
    priority = 1000,
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', '<C-a>', vim.lsp.buf.code_action, opts)
        end,
      })

      vim.lsp.enable('dockerls')
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('rust_analyzer')
      --
      -- -- Optional: Set up keybindings and inlay hints on attach
      -- vim.api.nvim_create_autocmd('LspAttach', {
      --   callback = function(args)
      --     local client = vim.lsp.get_client_by_id(args.data.client_id)
      --     if client.name == 'rust_analyzer' then
      --       local bufnr = args.buf
      --
      --       -- Enable inlay hints
      --       vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      --
      --       -- Keybindings
      --       vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
      --       vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
      --       vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
      --       vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
      --       vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr })
      --
      --       -- Rust-specific: expandMacro, joinLines, etc.
      --       vim.keymap.set('n', '<leader>em', function()
      --         vim.cmd.RustLsp('expandMacro')
      --       end, { buffer = bufnr, desc = 'Expand macro' })
      --     end
      --   end,
      -- })
      -- vim.lsp.enable('rust_analyzer')
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    version = false, -- last release is way too old
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    -- Not all LSP servers add brackets when completing a function.
    -- To better deal with this, LazyVim adds a custom option to cmp,
    -- that you can configure. For example:
    --
    -- ```lua
    -- opts = {
    --   auto_brackets = { "python" }
    -- }
    -- ```
    opts = function()
      vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })

      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
      local cmp = require('cmp')
      local defaults = require('cmp.config.default')()
      local auto_select = true
      return {
        auto_brackets = {}, -- configure any filetype to auto add brackets
        completion = {
          completeopt = 'menu,menuone,noinsert' .. (auto_select and '' or ',noselect'),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm { select = auto_select },
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-CR>'] = function(fallback)
            cmp.abort()
            fallback()
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
        sorting = defaults.sorting,
      }
    end,
  },
  {
    'stevearc/oil.nvim',
    config = function()
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
    end,
  },
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').set_default_mappings()
    end,
  },
  {
    'echasnovski/mini.nvim',
    config = function()
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
    end,
  },
  {
    'catppuccin/nvim',
    lazy = false,
    config = function()
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
    end,
  },
  {
    'stevearc/conform.nvim',
    config = function()
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
    end,
  },
  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup {}
    end,
  },
}
