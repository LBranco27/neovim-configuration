-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local bootstrap = false

if fn.empty(fn.glob(install_path)) > 0 then
	bootstrap = true
	fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	vim.cmd [[packadd packer.nvim]]
end

local cargo_bin = vim.fn.expand("~/.cargo/bin")
if vim.env.PATH and not vim.env.PATH:find(cargo_bin, 1, true) then
	vim.env.PATH = cargo_bin .. ":" .. vim.env.PATH
end

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use { "ellisonleao/gruvbox.nvim" }
	use {
		'nvim-telescope/telescope.nvim',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use ('theprimeagen/harpoon')
	use ('mbbill/undotree')
	use {
		"williamboman/mason.nvim",
		run = ":MasonUpdate" -- :MasonUpdate updates registry contents
	}
	use {
		'VonHeikemen/lsp-zero.nvim',
		requires = {
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason-lspconfig.nvim'},
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'hrsh7th/cmp-cmdline'},
			{'L3MON4D3/LuaSnip'},
			{'saadparwaiz1/cmp_luasnip'}
		}
	}
	use {'mfussenegger/nvim-dap'}
	use {'mfussenegger/nvim-jdtls'}
	use {'aklt/plantuml-syntax'}
	use {"akinsho/toggleterm.nvim", tag = '*', config = function() end}
	use {
		'kkoomen/vim-doge',
		run = ':call doge#install()'
	}
	use {'lewis6991/gitsigns.nvim'}
	use {'onsails/lspkind.nvim'}
	use {'hrsh7th/cmp-nvim-lua'}
	use {
		"alexpasmantier/pymple.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- optional (nicer ui)
			"stevearc/dressing.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		run = ":PympleBuild",
	}

	if bootstrap then
		require('packer').sync()
	end
end, {
	git = {
		clone_timeout = 600,
	},
	auto_clean = true,
	compile_on_sync = true,
})
