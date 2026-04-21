return {
	{ "williamboman/mason.nvim", build = ":MasonUpdate" },
	{ "neovim/nvim-lspconfig" },
	{ "mfussenegger/nvim-dap" },
	{ "mfussenegger/nvim-jdtls" },
	{
		"alexpasmantier/pymple.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"stevearc/dressing.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		build = ":PympleBuild",
	},
}
