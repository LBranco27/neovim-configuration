local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
	return
end

pcall(function()
	require("dap-virtual-text").setup({ commented = true })
end)

dap.adapters.godot = {
	type = "server",
	host = "127.0.0.1",
	port = 6006,
}
dap.configurations.gdscript = {
	{
		type = "godot",
		request = "launch",
		name = "Launch scene",
		project = "${workspaceFolder}",
		launch_scene = true,
	},
}

pcall(function()
	require("dap-python").setup("python")
end)

pcall(function()
	local dapui = require("dapui")
	dapui.setup()
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end
end)

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Conditional breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
vim.keymap.set("n", "<leader>du", dap.up, { desc = "Up stack frame" })
vim.keymap.set("n", "<leader>dd", dap.down, { desc = "Down stack frame" })
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run last config" })
