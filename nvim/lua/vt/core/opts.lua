vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.guicursor = ""


vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.opt.colorcolumn = "80"

vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.rnu = true
-- System clipboard
vim.opt.clipboard = "unnamedplus"
-- Removes default '-- INSERT --', i have my bar
vim.opt.showmode = false

vim.cmd("set nocompatible")

vim.opt.shortmess = vim.opt.shortmess + {
  c = true, -- Do not show completion messages in command line
  F = true, -- Do not show file info when editing a file, in the command line
  W = true, -- Do not show "written" in command line when writing
  I = true, -- Do not show intro message when starting Vim
}

vim.keymap.set('', "<leader>-", vim.cmd.split)
vim.keymap.set('', "<leader>=", vim.cmd.vsplit)
vim.keymap.set('', "<leader>w", vim.cmd.w)
