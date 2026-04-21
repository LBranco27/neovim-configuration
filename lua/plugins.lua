local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

local cargo_bin = vim.fn.expand("~/.cargo/bin")
if vim.env.PATH and not vim.env.PATH:find(cargo_bin, 1, true) then
	vim.env.PATH = cargo_bin .. ":" .. vim.env.PATH
end

vim.g.OmniSharp_server_use_mono = 1
vim.g["prettier#config#tab_width"] = 8
vim.g["prettier#config#use_tabs"] = "true"

require("lazy").setup({
	{ import = "plugins.specs.ui" },
	{ import = "plugins.specs.editor" },
	{ import = "plugins.specs.coding" },
	{ import = "plugins.specs.lsp" },
	{ import = "plugins.specs.lang" },
	{ import = "plugins.specs.tools" },
}, {
	defaults = {
		lazy = false,
	},
	install = {
		colorscheme = { "gruvbox" },
	},
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
	change_detection = {
		notify = false,
	},
	performance = {
		cache = {
			enabled = false,
		},
	},
})
