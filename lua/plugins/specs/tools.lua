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

local function get_claude_terminal_bufnr()
	local ok, terminal = pcall(require, "claudecode.terminal")
	if ok and type(terminal.get_active_terminal_bufnr) == "function" then
		return terminal.get_active_terminal_bufnr()
	end
end

local function get_claude_terminal_state()
	local bufnr = get_claude_terminal_bufnr()
	if not bufnr then
		return { open = false, focused = false }
	end

	return get_terminal_state(bufnr)
end

---Footer of Claude's agent view, or nil when the chat is on screen.
local function get_agent_view_footer(bufnr)
	local banner, footer = false, nil
	for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, -61, -1, false)) do
		-- Prefix short enough not to wrap in a narrow split.
		banner = banner or line:find("conversation moved to the", 1, true) ~= nil
		if line:match("%S") then
			footer = line
		end
	end
	if banner and footer and (footer:find("enter to return", 1, true) or footer:find("enter to create", 1, true)) then
		return footer
	end
end

---Leaves Claude's agent view, then calls on_chat.
---Esc is sent only while the agent view is on screen: in the chat it would interrupt the model.
local function return_to_claude_chat(bufnr, on_chat, tries)
	tries = tries or 3
	local footer = get_agent_view_footer(bufnr)
	if not footer then
		-- A chat reattached from the agent view drops input for a few hundred ms.
		if tries < 3 then
			return vim.defer_fn(on_chat, 500)
		end
		return on_chat()
	end
	if tries == 0 then
		return vim.notify("Claude is still in the agent view; nothing sent", vim.log.levels.WARN)
	end

	-- Esc clears a typed prompt first, then returns to the chat; wait for each redraw.
	vim.api.nvim_chan_send(vim.bo[bufnr].channel, "\27")
	local waited_ms = 0
	local function wait_redraw()
		if get_agent_view_footer(bufnr) ~= footer or waited_ms >= 1000 then
			return return_to_claude_chat(bufnr, on_chat, tries - 1)
		end
		waited_ms = waited_ms + 50
		vim.defer_fn(wait_redraw, 50)
	end
	vim.defer_fn(wait_redraw, 50)
end

---Types an @mention of the cursor line or visual range into this Neovim's Claude terminal.
---IDE @mentions miss a chat that has been through the agent view; typed text reaches whatever chat is shown.
local function type_claude_mention(bufnr)
	local first, last = vim.fn.line("v"), vim.fn.line(".")
	first, last = math.min(first, last), math.max(first, last)
	local claude_cwd = vim.uv.fs_readlink("/proc/" .. vim.fn.jobpid(vim.bo[bufnr].channel) .. "/cwd")
	local file = vim.api.nvim_buf_get_name(0)
	local path = claude_cwd and vim.fs.relpath(claude_cwd, file) or file
	local range = first == last and ("#L" .. first) or ("#L%d-%d"):format(first, last)
	if vim.fn.mode() ~= "n" then
		vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
	end

	return_to_claude_chat(bufnr, function()
		require("claudecode.terminal").send_to_terminal(" @" .. path .. range .. " ", { submit = false })
	end)
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
		local bufnr = get_claude_terminal_bufnr()
		if bufnr and vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= "" then
			type_claude_mention(bufnr)
		elseif vim.fn.mode() == "n" then
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
