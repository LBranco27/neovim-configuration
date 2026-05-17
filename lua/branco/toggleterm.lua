local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
	return
end

toggleterm.setup()
vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm direction=float<CR>", { desc = "Floating terminal" })
vim.keymap.set("t", "<C-t>", "<cmd>ToggleTerm<CR>")
