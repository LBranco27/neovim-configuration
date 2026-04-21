return {
	{ "ellisonleao/gruvbox.nvim", priority = 1000 },
	{ "nvim-tree/nvim-web-devicons" },
	{ "preservim/nerdtree" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup()
		end,
	},
}
