local opencode_cmd = "opencode --port"
local snacks_terminal_opts = {
	win = {
		position = "right",
		enter = false,
	},
}

local agent_router_state = {
	last_toggled_agent = "claude",
}

local function is_buffer_visible(bufnr)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end

	local buffer_info = vim.fn.getbufinfo(bufnr)[1]
	for _, win in ipairs(buffer_info and buffer_info.windows or {}) do
		if vim.api.nvim_win_is_valid(win) then
			local ok, config = pcall(vim.api.nvim_win_get_config, win)
			if not ok or config.hide ~= true then
				return true
			end
		end
	end
	return false
end

local function get_terminal_state(bufnr)
	local open = is_buffer_visible(bufnr)
	return {
		open = open,
		focused = open and vim.api.nvim_get_current_buf() == bufnr,
	}
end

local function get_claude_terminal_state()
	local ok, terminal = pcall(require, "claudecode.terminal")
	if not ok or type(terminal.get_active_terminal_bufnr) ~= "function" then
		return { open = false, focused = false }
	end

	return get_terminal_state(terminal.get_active_terminal_bufnr())
end

local function get_opencode_terminal_state()
	local ok, terminal = pcall(require, "snacks.terminal")
	if not ok then
		return { open = false, focused = false }
	end

	local opencode_terminal = terminal.get(opencode_cmd, { create = false })
	return get_terminal_state(opencode_terminal and opencode_terminal.buf)
end

local function current_agent()
	local claude = get_claude_terminal_state()
	local opencode = get_opencode_terminal_state()

	if claude.focused then
		return "claude"
	elseif opencode.focused then
		return "opencode"
	elseif claude.open and not opencode.open then
		return "claude"
	elseif opencode.open and not claude.open then
		return "opencode"
	elseif claude.open and opencode.open then
		return agent_router_state.last_toggled_agent
	end

	return "claude"
end

local function execute_without_focus(command)
	local current_window = vim.api.nvim_get_current_win()
	vim.cmd(command)
	if vim.api.nvim_win_is_valid(current_window) then
		vim.api.nvim_set_current_win(current_window)
	end
end

local function toggle_claude()
	agent_router_state.last_toggled_agent = "claude"
	execute_without_focus("ClaudeCode")
end

local function route_to_agent()
	if current_agent() == "claude" then
		if not get_claude_terminal_state().open then
			agent_router_state.last_toggled_agent = "claude"
		end
		if vim.fn.mode() == "n" then
			execute_without_focus("ClaudeCodeAdd %")
		else
			execute_without_focus("ClaudeCodeSend")
		end
	else
		require("opencode").ask("@this: ")
	end
end

return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		opts = {
			terminal_cmd = "claude",
			focus_after_send = false,
			terminal = {
				provider = "snacks",
				split_side = "right",
				snacks_win_opts = {
					enter = false,
				},
			},
		},
		config = function(_, opts)
			require("claudecode").setup(opts)
		end,
	},
	{
		"nickjvandyke/opencode.nvim",
		branch = "main",
		config = function()
			---@type opencode.Opts
			vim.g.opencode_opts = {
				server = {
					start = function()
						agent_router_state.last_toggled_agent = "opencode"
						require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
					end,
				},
			}
			vim.o.autoread = true

			vim.keymap.set({ "n", "x" }, "<C-a>", route_to_agent, { desc = "Send to active agent" })
			vim.keymap.set({ "n", "t" }, "<F11>", toggle_claude, { desc = "Toggle Claude Code" })
			vim.keymap.set({ "n", "x" }, "<C-x>", function()
				require("opencode").select()
			end, { desc = "Select opencode" })
			local toggle_opencode = function()
				agent_router_state.last_toggled_agent = "opencode"
				require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
			end
			vim.keymap.set({ "n", "t" }, "<C-.>", toggle_opencode, { desc = "Toggle opencode" })
			vim.keymap.set("n", "<leader>.", toggle_opencode, { desc = "Toggle opencode" })
			vim.keymap.set({ "n", "t" }, "<F12>", toggle_opencode, { desc = "Toggle opencode" })
			vim.keymap.set({ "n", "x" }, "go", function()
				return require("opencode").operator("@this ")
			end, { desc = "Add range to opencode", expr = true })
			vim.keymap.set("n", "goo", function()
				return require("opencode").operator("@this ") .. "_"
			end, { desc = "Add line to opencode", expr = true })
			vim.keymap.set("n", "<S-C-k>", function()
				require("opencode").command("session.half.page.up")
			end, { desc = "Scroll opencode up" })
			vim.keymap.set("n", "<S-C-d>", function()
				require("opencode").command("session.half.page.down")
			end, { desc = "Scroll opencode down" })
			vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
			vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })

			-- Show terminal on prompt submit
			vim.api.nvim_create_autocmd("User", {
				pattern = "OpencodeEvent:tui.command.execute",
				callback = function(args)
					---@type opencode.server.Event
					local event = args.data.event
					if event.properties.command == "prompt.submit" then
						agent_router_state.last_toggled_agent = "opencode"
						local win = require("snacks.terminal").get(opencode_cmd, { create = false })
						if win then
							win:show()
						end
					end
				end,
			})
		end,
	},
}
