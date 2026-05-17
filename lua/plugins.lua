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
			enabled = true,
		},
	},
})
