return {
	{ "ellisonleao/gruvbox.nvim", priority = 1000 },
	{ "nvim-tree/nvim-web-devicons" },
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local function on_attach(bufnr)
				local api = require("nvim-tree.api")
				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end
				-- load all default keymaps
				api.map.on_attach.default(bufnr)
				-- drop nvim-tree's <C-t> so the global toggleterm <C-t> works in the tree
				pcall(vim.keymap.del, "n", "<C-t>", { buffer = bufnr })
				-- remap nvim-tree's "open in new tab" to <C-o>
				vim.keymap.set("n", "<C-o>", api.node.open.tab, opts("Open: In New Tab"))
			end
			require("nvim-tree").setup({
				on_attach = on_attach,
				view = { width = 35 },
				renderer = { group_empty = true },
				filters = { dotfiles = false },
				git = { enable = true, timeout = 4000 },
				actions = { open_file = { quit_on_open = false } },
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						"alpha",
						"dashboard",
						"NvimTree",
						"Outline",
						"packer",
						"diff",
					},
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filesize" },
					lualine_y = { "progress" },
					lualine_z = {
						{
							function()
								local ok, opencode = pcall(require, "opencode")
								return ok and opencode.statusline() or ""
							end,
						},
						"location",
					},
				},
				inactive_sections = {
					lualine_a = { "filename" },
					lualine_b = {},
					lualine_c = { "filepath" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = {},
			})
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("snacks").setup({
				input = { enabled = true },
				terminal = { enabled = true },
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				win = { border = "rounded" },
			})
		end,
	},
}
