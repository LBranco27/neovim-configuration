vim.opt.wrap = false
vim.opt.guicursor = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.updatetime = 50
vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"
vim.opt.title = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

local undo_dir = vim.fn.stdpath("state") .. "/undo"
vim.opt.undodir = undo_dir
vim.fn.mkdir(undo_dir, "p")
vim.opt.undofile = true

vim.opt.termguicolors = true
vim.cmd.filetype("indent plugin on")
