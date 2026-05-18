local ok, ts = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end

ts.setup({
	ensure_installed = {
		"python",
		"lua",
		"bash",
		"json",
		"markdown",
		"markdown_inline",
		"regex",
		"vimdoc",
	},
	highlight = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
			goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
			goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
			goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
		},
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gd", "gdscript3" },
	callback = function(args)
		vim.bo[args.buf].filetype = "gdscript"
	end,
})
