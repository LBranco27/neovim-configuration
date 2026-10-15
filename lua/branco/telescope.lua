local ok, builtin = pcall(require, "telescope.builtin")
if not ok then
	return
end

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep files" })
vim.keymap.set("n", "<leader>fG", function()
	local path = vim.fn.expand("%:p:h")
	if vim.bo.filetype == "NvimTree" then
		local node = require("nvim-tree.api").tree.get_node_under_cursor()
		path = node.type == "directory" and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
	end
	builtin.live_grep({ search_dirs = { path } })
end, { desc = "Grep in directory" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>ft", builtin.git_files, { desc = "Git files" })
vim.keymap.set("n", "<leader>gn", builtin.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
