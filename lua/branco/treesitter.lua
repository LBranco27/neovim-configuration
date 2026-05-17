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
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gd", "gdscript3" },
	callback = function(args)
		vim.bo[args.buf].filetype = "gdscript"
	end,
})
