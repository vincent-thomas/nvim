---@brief
---
--- https://github.com/golang/tools/tree/master/gopls
---
--- Google's lsp server for golang.

local mod_cache = nil
local std_lib = nil

---@param envvar_id string
---@param custom_subdir? string
---@return string?
local function identify_go_dir_sync(envvar_id, custom_subdir)
  local cmd = { 'go', 'env', envvar_id }
  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 or not result.stdout then
    vim.schedule(function()
      vim.notify(
        ('[gopls] identify %s dir failed with code %d: %s\n%s'):format(
          envvar_id,
          result.code,
          vim.inspect(cmd),
          result.stderr or ''
        )
      )
    end)
    return nil
  end
  local res = vim.trim(result.stdout)
  if res == '' then
    return nil
  end
  if custom_subdir and custom_subdir ~= '' then
    res = res .. custom_subdir
  end
  return res
end

---@param fname string
---@return string?
local function get_root_dir(fname)
  if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
    local clients = vim.lsp.get_clients { name = 'gopls' }
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  if std_lib and fname:sub(1, #std_lib) == std_lib then
    local clients = vim.lsp.get_clients { name = 'gopls' }
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  return vim.fs.root(fname, 'go.work') or vim.fs.root(fname, 'go.mod') or vim.fs.root(fname, '.git')
end

---@type vim.lsp.Config
return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    -- Sync lookups — these are fast `go env` calls, cached after first invocation
    if not mod_cache then
      mod_cache = identify_go_dir_sync('GOMODCACHE')
    end
    if not std_lib then
      std_lib = identify_go_dir_sync('GOROOT', '/src')
    end
    -- see: https://github.com/neovim/nvim-lspconfig/issues/804
    on_dir(get_root_dir(fname))
  end,
}
