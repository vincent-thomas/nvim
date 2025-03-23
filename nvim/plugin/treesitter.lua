local config = {
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    enable_autocmd = false,
    disable = function(lang, buf)
      if lang == 'html' then
        print('disabled')
        return true
      end

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
