-- Gitsigns
local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
if gitsigns_ok then
	gitsigns.setup({
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged_enable = true,
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = { follow_files = true },
		auto_attach = true,
		attach_to_untracked = false,
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
			ignore_whitespace = false,
			virt_text_priority = 100,
			use_focus = true,
		},
		current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		sign_priority = 6,
		update_debounce = 100,
		max_file_length = 40000,
		preview_config = {
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
		on_attach = function(bufnr)
			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
				vim.cmd.normal({ "zz", bang = true })
			end)

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
				vim.cmd.normal({ "zz", bang = true })
			end)

			map("n", "<leader>hs", gitsigns.stage_hunk)
			map("n", "<leader>hr", gitsigns.reset_hunk)

			map("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)
			map("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)

			map("n", "<leader>hS", gitsigns.stage_buffer)
			map("n", "<leader>hR", gitsigns.reset_buffer)
			map("n", "<leader>hp", gitsigns.preview_hunk)
			map("n", "<leader>hi", gitsigns.preview_hunk_inline)
			map("n", "<leader>hb", function()
				gitsigns.blame_line({ full = true })
			end)
			map("n", "<leader>hd", gitsigns.diffthis)
			map("n", "<leader>hD", function()
				gitsigns.diffthis("~")
			end)
			map("n", "<leader>hQ", function()
				gitsigns.setqflist("all")
			end)
			map("n", "<leader>hq", gitsigns.setqflist)
			map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
			map("n", "<leader>tw", gitsigns.toggle_word_diff)
			map({ "o", "x" }, "ih", gitsigns.select_hunk)
		end,
	})
end

-- Global ]c / [c always center screen (buffer-local gitsigns ones override these)
vim.keymap.set("n", "]c", function()
	vim.cmd.normal({ "]c", bang = true })
	vim.cmd.normal({ "zz", bang = true })
end, { desc = "Next diff/hunk and center" })

vim.keymap.set("n", "[c", function()
	vim.cmd.normal({ "[c", bang = true })
	vim.cmd.normal({ "zz", bang = true })
end, { desc = "Prev diff/hunk and center" })

-- Suppress diagnostics when buffer has git conflict markers
local function buf_has_conflicts(bufnr)
	for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
		if line:find("^<<<<<<<") then
			return true
		end
	end
	return false
end

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		if buf_has_conflicts(args.buf) then
			vim.diagnostic.enable(false, { bufnr = args.buf })
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function(args)
		if not buf_has_conflicts(args.buf) then
			vim.diagnostic.enable(true, { bufnr = args.buf })
		end
	end,
})

-- Restart LSP + reload buffers when git HEAD changes
local git_head_cache = {}
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	callback = function()
		local root = vim.fs.root(0, { ".git" })
		if not root then
			return
		end
		local ok, head = pcall(function()
			return vim.trim(vim.fn.system("git -C " .. vim.fn.shellescape(root) .. " rev-parse HEAD"))
		end)
		if not ok or head == "" then
			return
		end
		if git_head_cache[root] and git_head_cache[root] ~= head then
			vim.cmd("checktime")
			for _, client in ipairs(vim.lsp.get_clients()) do
				pcall(vim.lsp.stop_client, client.id, true, true)
			end
			vim.notify("Git HEAD changed — LSP restarted", vim.log.levels.INFO)
		end
		git_head_cache[root] = head
	end,
})
