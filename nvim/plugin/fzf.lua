
local fzf = require("fzf-lua")

fzf.setup()

local function find_files()
  fzf.files({
    previewer = false,
    fzf_opts = { ["--layout"] = "reverse-list" },
    winopts = { row = 1, width = 0.5, height = 0.5 },
  })
end

vim.keymap.set("n", "<C-f>", find_files)
vim.keymap.set("n", "<C-g>", fzf.live_grep)
-- vim.keymap.set("n", "<leader>e", fzf.lsp_document_diagnostics)
-- vim.keymap.set("n", "<leader>a", fzf.lsp_code_actions)
vim.keymap.set("n", "<C-b>", fzf.buffers)
