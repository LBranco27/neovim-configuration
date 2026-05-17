require("branco.options")
require("branco.treesitter")
require("branco.telescope")
require("branco.harpoon")
require("branco.toggleterm")
require("branco.keymaps")
require("branco.lsp")
require("branco.cmp")
require("branco.dap")
require("branco.git")

-- Mason
pcall(function()
	require("mason").setup()
end)

-- vim-doge
vim.g.doge_doc_standard_python = "google"
vim.g.doge_enable = 1

vim.api.nvim_create_user_command("UpdateAll", function()
	for _, command in ipairs({ "Lazy sync", "MasonUpdate", "TSUpdate" }) do
		local ok, err = pcall(vim.cmd, command)
		if not ok then
			vim.notify("UpdateAll: failed on `" .. command .. "`\n" .. tostring(err), vim.log.levels.WARN)
			return
		end
	end
	vim.notify("UpdateAll: finished", vim.log.levels.INFO)
end, { desc = "Update plugins, tools, and parsers" })

-- nvim-lint
pcall(function()
	require("lint").linters_by_ft = { python = { "ruff" } }
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
		callback = function()
			require("lint").try_lint()
		end,
	})
end)

-- Conform (format on save)
pcall(function()
	require("conform").setup({
		formatters_by_ft = {
			python = { "ruff_format" },
			lua = { "stylua" },
		},
		format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
	})
end)

-- venv-selector
pcall(function()
	require("venv-selector").setup()
end)

-- Neotest
pcall(function()
	require("neotest").setup({
		adapters = {
			require("neotest-python")({
				runner = "pytest",
			}),
		},
	})
	local neotest = require("neotest")
	vim.keymap.set("n", "<leader>tn", function()
		neotest.run.run()
	end, { desc = "Run nearest test" })
	vim.keymap.set("n", "<leader>tf", function()
		neotest.run.run(vim.fn.expand("%"))
	end, { desc = "Run file tests" })
	vim.keymap.set("n", "<leader>ts", function()
		neotest.summary.toggle()
	end, { desc = "Toggle test summary" })
end)
