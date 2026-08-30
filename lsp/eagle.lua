---@brief
---
--- https://github.com/mistachkin/eagle-lsp
---
--- Eagle Language Server - LSP for the Eagle scripting language (Tcl for .NET/CLR)

---@type vim.lsp.Config
return {
  cmd = { 'eagle-lsp' },
  filetypes = { 'eagle', 'tcl' },
  root_markers = { '.git' },
}
