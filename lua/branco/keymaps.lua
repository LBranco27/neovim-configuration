vim.keymap.set("", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("", "<leader>p", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("", "<leader>P", '"+P', { desc = "Paste before from clipboard" })
vim.keymap.set("n", "<leader>t", function()
	require("nvim-tree.api").tree.toggle({ find_file = true })
end, { desc = "Toggle file tree" })

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("nvim-tree.api").tree.open()
		vim.cmd.wincmd("p")
	end,
})
vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<leader>ww", function()
	vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle word wrap" })
vim.keymap.set("n", "<leader>gg", ":tabnew | Git<CR>", { noremap = true, silent = true, desc = "Fugitive" })
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.UndotreeToggle()
end, { desc = "Undotree" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
