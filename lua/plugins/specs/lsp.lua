return {
	{ "williamboman/mason.nvim", build = ":MasonUpdate" },
	{ "neovim/nvim-lspconfig" },
	{ "mfussenegger/nvim-dap" },
	{ "mfussenegger/nvim-dap-python", ft = "python" },
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	{ "mfussenegger/nvim-jdtls" },
	{ "mfussenegger/nvim-lint" },
	{ "stevearc/conform.nvim" },
	{ "linux-cultist/venv-selector.nvim", ft = "python" },
	{ "nvim-neotest/neotest", dependencies = { "nvim-neotest/neotest-python" } },
}
