local config = {
  highlight = {
    enable = false,
    additional_vim_regex_highlighting = false,
    enable_autocmd = false,
  },
  sync_install = false,
  indent = { enable = false },
}

require("nvim-treesitter.configs").setup(config)
