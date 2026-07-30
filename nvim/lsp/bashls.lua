---@brief
---
--- https://github.com/bash-lsp/bash-language-server
---
--- Bash language server (aka bash-language-server)

---@type vim.lsp.Config
return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash', 'zsh' },
  root_markers = { '.git' },
}
